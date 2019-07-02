# Lightweight template tool for Linux shell

`tcat` means `cat` shell template files.

Think about `tcat` as a tool similar to `zcat`. `cat` prints the contents of input files. `zcat` first unzips the input files, then prints their contents. `tcat` first replaces the variable name with their values in the input template files, then prints the rendered contents.

## Usage

`tcat` accepts one ore more template files as input, and writes output to STDOUT after replacing variables with their values. If no template files are specified, it reads input from STDIN by default.

```bash
tcat.sh [template-file ...]
```

All variables in template files must be defined and visible from within the script, otherwise the command will fail.

## Examples

### Read from STDIN

```bash
$ echo "My name is \${USER}" | ./tcat.sh
```

Output:

```
My name is functicons
```

Note that in this example, we don't need to explicitly define `USER`, because it is a predefined shell environment variable. Also we should use `\${USER}` instead `${USER}`; otherwise, the variable will be replaced by Bash before it reaches `tcat`.

### Read from template files

Template file:

```
Hello ${name}!

Sentence: ${sentence}

Escape: \${foo}

Quote: "foo" 'bar'

Environment variable \${USER}: ${USER}
```

Optionally, you could define variables in a properties file:

```bash
name=world
sentence="this is a sentence"
```

Then start a child process, load and export variables, render the template:

```bash
$ (source examples/properties; export $(cut -d= -f1 examples/properties); ./tcat.sh examples/template)
```

Output:

```
Hello world!

Sentence: this is a sentence

Escape: ${foo}

Quote: "foo" 'bar'

Environment variable ${USER}: functicons
```
