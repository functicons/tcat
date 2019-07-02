# Lightweight template tool for Linux shell

Think about `tcat` as something similar to `zcat`. `cat` prints the contents of text files; `zcat` first unzips the input files, then prints their contents; while `tcat` first replaces variables in the input template files, then prints the contents of the files.

## Usage

`tcat` accepts N template files as input, where N >= 0, and writes output to STDOUT after replacing variables with their values. If no template files are specified, it reads input from STDIN.

```bash
./tcat.sh [template-file ...]
```

All variables in template files must be defined, otherwise the command will fail.

## Examples

### Read from STDIN

```bash
$ echo "My name is \${USER}" | ./tcat.sh
```

Output:

```
My name is functicons
```

Note that in this example, you should use `\${USER}` instead `${USER}`;
otherwise, the variable will be replaced by Bash before it reaches `tcat`.

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
