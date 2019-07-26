###########################
# 'Hello, world!' Snakemake example
# 
# By Jeffrey M. Perkel, with help from Johannes Koester
###########################

hello_string = "Hello, world! My name is"
chunk_len = 6
with open("name.txt","r") as f:
    text = f.readline()
mylen = int(len(hello_string + text)/chunk_len)+1
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
        'echo "{hello_string} `cat {input}`!" > {output}'

rule split:
    input:
        "hello-world.txt"
    output:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks
    shell:
        'echo `cat {input}` | split -b {chunk_len} - chunk_'        

rule toupper:
    input:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks 
    output:
        "hello-world-upper.txt"
    shell:
        'echo `cat {input}` | tr "[:lower:]" "[:upper:]" >> {output}'
