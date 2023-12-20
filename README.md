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
```xml
python setup.py install
nextvirus -h
```

### 1.3. Or run the source code directly

you can also directly run the source code of nextvirus without installation. Please view the help documentation by ```python main.py -h```.


## 2. Software dependencies

The running of ```nextvirus``` relies on these softwares:

+  [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) (version >=0.39), which is used to remove the contamination from adapter primer.

+  [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) (version >=2.3.5), which is used to remove the contamination from host genome.

+  [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) (version >=2.15.1), in the second sub-pipeline of nextvirus, the Trinity is used to splice reads to contigs.

+  [diamond](https://github.com/bbuchfink/diamond) (version >=2.0.9), the diamond is used to map reads or contigs to viral proteins.

<b>Note</b>, these dependencies need to be installed manually by users beforehand. 


## 3. Configuration of dependent software and database
In order to manage the path and parameters of theses dependent software convenienty, the ```xml``` file is used to record the their configuration. In general, paths and parameters of software only need to be configured once in the first running, except for the host database used to filter contamination.

### 3.1. about *.xml file
The template (profiles.xml) of configuration is provided in the github repository, please note,

+ currently version of nextvirus only supports the processing of paired-end sequencing data from Illumina platform.
  
+ the paths of these software and databases need to be adjusted with reference to your computer. 
  
+ the parameters of software in this *.xml file generally does not need to be modified because they are suitable.


### 3.2. how to creat a host database?
+ download the host's genomic with *.fasta format.
+ creat the host database using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), for example,
 ```bowtie2-build /path/human_hg38_refMrna.fna /path/human_hg38_refMrna```.
Then, the path ```/path/human_hg38_refMrna``` is filled in ```<database name="hostdb">``` section of file ```profiles.xml```. 

### 3.3. how to creat a viral nr database?
+ download the refseq sequence of viral nr from [NCBI](https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/).
+ creat the viral nr database using [diamond](https://github.com/bbuchfink/diamond), for example, 
```diamond makedb -p 20 --in /path/protein.fasta --db /path/protein.dmnd```. Then, the path ```/path/to/protein.dmnd``` is filled in ```<database name="viral_nr">``` of file ```profiles.xml```. 

### 3.4. how to creat a viral taxonomy?
The viral taxonomy information is used to classfy viral reads, this repository provides the [species_information-2021-05-20.txt]() organized by ourselves. If you want to add information, keep it in the same format.

