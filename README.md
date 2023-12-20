# nextvirus: rapid identifying and classifying viral reads from high-throughput sequencing (illumina).

## 1. Download and install

nextvirus is developed via ```Python 3```, and you can get and install nextvirus in a variety of ways.

### 1.1. pip method

nextvirus has been distributed to the standard library of ```PyPI```, and can be easily installed by the tool ```pip```.

```
pip install nextvirus
nextvirus -h
```

### 1.2. Or local installation

In addition to the  ```pip``` method, you can also install nextvirus manually using the file ```setup.py```. 

Firstly, download this repository, then, run:
```
python setup.py install
nextvirus -h
```

### 1.3. Or run the source code directly

you can also directly run the source code of nextvirus without installation. Please view the help documentation by ```python main.py -h```.


## 2. Software dependencies

The running of ```nextvirus``` relies on these softwares:

(1) [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) (version >=0.39), which is used to remove the contamination from adapter primer.

(2) [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) (version >=2.3.5), which is used to remove the contamination from host genome.

(3) [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) (version >=2.15.1), in the second sub-pipeline of nextvirus, the Trinity is used to splice reads to contigs.

(4) [diamond](https://github.com/bbuchfink/diamond) (version >=2.0.9), the diamond is used to map reads or contigs to viral proteins.

<b>Note</b>, these dependencies need to be installed manually by users beforehand. 


## 3. Configuration of dependent software and database


