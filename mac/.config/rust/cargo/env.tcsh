# rustup environment for tcsh
if ( $?PATH ) then
    if ( "$PATH" !~ *$CARGO_HOME/bin* ) then
        setenv PATH "$CARGO_HOME/bin:$PATH"
    endif
else
    setenv PATH "$CARGO_HOME/bin"
endif
