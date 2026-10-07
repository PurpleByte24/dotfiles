# Mac-only completion overrides (sourced after Oh-My-Zsh, so compinit has run)

# zsh's _java completes class names; complete file paths instead (single-file `java Foo.java`)
compdef _files java
