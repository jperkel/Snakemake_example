str = "Hello, world! My name is"
chunklen = 6
with open("name.txt","r") as f:
    text = f.read()
mylen = int(len(str + text)/chunklen)+1
letters = "abcdefghijklmnopqrstuvwxyz"
chunks = ["a{letter}".format(letter = letter) for letter in letters[0:mylen]]

rule all:
    input:
        "hello-world-upper.txt"

rule clean:
    shell:
        "rm -f chunk_a* hello-world.txt hello-world-upper.txt"

rule helloworld:
    input:
        "name.txt"
    output:
        "hello-world.txt"
    shell:
        'echo "{str} `cat {input}`!" > {output}'

rule split:
    input:
        "hello-world.txt"
    output:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks
    shell:
        'echo `cat {input}` | split -b {chunklen} - chunk_'        

rule toupper:
    input:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks 
    output:
        "hello-world-upper.txt"
    shell:
        'echo `cat {input}` | tr "[:lower:]" "[:upper:]" >> {output}'
