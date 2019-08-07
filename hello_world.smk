###########################
# 'Hello, world!' Snakemake example
# 
# By Jeffrey M. Perkel, with help from Johannes Koester
# (Inspired/assisted by the Nextflow tutorial https://www.nextflow.io/docs/latest/getstarted.html) 
#
###########################

hello_string = "Hello, world! My name is"
chunk_len = 6 # number of bytes per file chunk in rule 'split'

with open("name.txt","r") as f:
    name = f.readline() # read first line of name.txt

# if there's a trailing carriage return, strip it out...
if name[len(name)-1] == '\n': name = name[0:len(name)-1]

mylen = int(len(hello_string + ' ' + name + '!')/chunk_len)+1
letters = "abcdefghijklmnopqrstuvwxyz"
chunks = ["a{letter}".format(letter = letter) for letter in letters[0:mylen]]

rule all:
    input:
        "hello-world-upper.txt"

# ht Titus Brown
# https://hackmd.io/7k6JKE07Q4aCgyNmKQJ8Iw
rule clean:
    shell:
        "rm -f chunk_a* hello-world.txt hello-world-upper.txt"

rule helloworld:
    output:
        "hello-world.txt"
    shell:
        'echo "{hello_string} {name}!" > {output}'

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
