final: prev: {
  hello-script = prev.writeShellScriptBin "hello" "echo Hello World!";
}
