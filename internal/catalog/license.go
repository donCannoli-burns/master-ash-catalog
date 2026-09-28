package catalog

import (
	"os"
	"path/filepath"
	"strings"
)

var licenseFiles = []string{"LICENSE", "LICENSE.md", "LICENSE.txt", "COPYING", "COPYING.md", "COPYING.txt", "UNLICENSE"}

func DetectLicense(repoDir string) License {
	for _, name := range licenseFiles {
		p := filepath.Join(repoDir, name)
		b, err := os.ReadFile(p)
		if err != nil {
			continue
		}
		text := strings.ToLower(string(b))
		lic := License{Status: "review", EvidencePath: name}
		switch {
		case strings.Contains(text, "mit license") || strings.Contains(text, "permission is hereby granted, free of charge"):
			lic.Status, lic.Name = "allowed", "MIT"
		case strings.Contains(text, "apache license") && strings.Contains(text, "version 2.0"):
			lic.Status, lic.Name = "allowed", "Apache-2.0"
		case strings.Contains(text, "mozilla public license"):
			lic.Status, lic.Name = "allowed", "MPL"
		case strings.Contains(text, "gnu lesser general public license"):
			lic.Status, lic.Name = "allowed", "LGPL"
		case strings.Contains(text, "gnu general public license"):
			lic.Status, lic.Name = "allowed", "GPL"
		case strings.Contains(text, "redistribution and use in source and binary forms"):
			lic.Status, lic.Name = "allowed", "BSD-style"
		case strings.Contains(text, "the unlicense") || strings.Contains(text, "this is free and unencumbered software released into the public domain"):
			lic.Status, lic.Name = "allowed", "Unlicense/Public Domain"
		case strings.Contains(text, "cc0") || strings.Contains(text, "creative commons zero"):
			lic.Status, lic.Name = "allowed", "CC0"
		default:
			lic.Reason = "License file found, but the synchronizer does not recognize it automatically. Manual review required."
		}
		return lic
	}
	return License{Status: "blocked", Reason: "No repository license file was detected. Public visibility is not permission to redistribute; metadata may be indexed, but script bytes are not vendored automatically."}
}
