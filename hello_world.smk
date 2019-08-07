###########################
# 'Hello, world!' Snakemake example
# 
# By Jeffrey M. Perkel, with help from Johannes Koester
# (Inspired/assisted by the Nextflow tutorial https://www.nextflow.io/docs/latest/getstarted.html) 
###########################

hello_string = "Hello, world, my name is"
chunk_len = 6 # number of bytes per file chunk in rule 'split'
tmpfile = "hello-world.tmp"

with open("name.txt","r") as f:
    name = f.readline() # read first line of name.txt

# if there's a trailing carriage return, strip it out...
name = name.strip()
msg = hello_string + ' ' + name + '!'

nFiles = int(len(msg)/chunk_len)+1
letters = "abcdefghijklmnopqrstuvwxyz"
chunks = ["a{letter}".format(letter = letter) for letter in letters[0:nFiles]]

rule all:
    input:
        "hello-world.txt"

# ht Titus Brown
# https://hackmd.io/7k6JKE07Q4aCgyNmKQJ8Iw
rule clean:
    shell:
        "rm -f chunk_a* {tmpfile} hello-world.txt"

rule helloworld:
    output:
        {tmpfile}
    shell:
        'echo {msg} > {output}'

rule split:
    input:
        {tmpfile}
    output:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks
    shell:
        'echo `cat {input}` | split -b {chunk_len} - chunk_'        

rule toupper:
    input:
        "chunk_{chunk}".format(chunk = chunk) for chunk in chunks 
    output:
        "hello-world.txt"
    shell:
        'echo `cat {input}` | tr "[:lower:]" "[:upper:]" >> {output}'
