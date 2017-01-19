package main

import (
	"flag"
	"fmt"

	"github.com/aryszka/trtest"
)

var (
	version      string
	commit       string
	printVersion bool
)

func init() {
	flag.BoolVar(&printVersion, "version", false, "print trtest version")
	flag.Parse()
}

func versionString() string {
	return fmt.Sprintf(
		"trtest version %s (commit: %s)",
		version, commit,
	)
}

func main() {
	if printVersion {
		println(versionString())
		return
	}

	println(trtest.Hello())
}
