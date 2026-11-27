#!/usr/bin/env python3
"""Validate observed baseline; never download or execute artifacts."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys
import urllib.request

BASELINE = Path(__file__).resolve().parent.parent / "manifests" / "artifacts.json"


def load_baseline(path):
    data = json.loads(path.read_text())
    digests = [data["uv"]["sha256"], data["ollama"]["installer_sha256"],
               data["ollama"]["binary_sha256"]]
    digests += [model["digest"] for model in data["models"]]
    if not all(re.fullmatch(r"[0-9a-f]{64}", digest) for digest in digests):
        raise ValueError("invalid SHA256")
    if len({m["name"] for m in data["models"]}) != len(data["models"]):
        raise ValueError("duplicate model")
    if not data["models"] or any(m["size"] <= 0 for m in data["models"]):
        raise ValueError("invalid model size")
    return data


def verify_file(path, expected):
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    if digest.hexdigest() != expected:
        raise ValueError(f"SHA256 mismatch: {path}")
    print(f"PASS: {path}")


def verify_models(expected, actual):
    installed = {m["name"]: m for m in actual}
    for model in expected:
        observed = installed.get(model["name"], {})
        if (observed.get("digest") != model["digest"]
                or observed.get("size") != model["size"]):
            raise ValueError(f"Model mismatch or missing: {model['name']}")
        print(f"PASS: {model['name']}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--uv")
    parser.add_argument("--ollama")
    parser.add_argument("--installer")
    parser.add_argument("--models", action="store_true")
    parser.add_argument("--manifest-only", action="store_true")
    args = parser.parse_args()
    try:
        data = load_baseline(BASELINE)
        if args.uv:
            verify_file(args.uv, data["uv"]["sha256"])
        if args.ollama:
            verify_file(args.ollama, data["ollama"]["binary_sha256"])
        if args.installer:
            verify_file(args.installer, data["ollama"]["installer_sha256"])
        if args.models:
            with urllib.request.urlopen("http://127.0.0.1:11434/api/tags", timeout=10) as response:
                verify_models(data["models"], json.load(response)["models"])
        if args.manifest_only:
            print("PASS: artifact manifest")
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
