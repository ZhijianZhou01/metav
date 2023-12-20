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

<b>Note</b>, these dependencies need to be installed manually by users beforehand. It is recommended that you specify the installation path when installing them.


## 3. Configuration of dependent software and database
In order to manage the path and parameters of theses dependent software convenienty, the ```xml``` file is used to record the their configuration. In general, paths and parameters of software only need to be configured once in the first running, except for the host database used to filter contamination.

### 3.1. about *.xml file
The template (profiles.xml) of configuration is provided in the github repository, please note,

+ currently version of nextvirus only supports the processing of paired-end sequencing data from Illumina platform.
  
+ the paths of these software and databases need to be adjusted with reference to your computer. 
  
+ the parameters of software in this *.xml file generally does not need to be modified because they are suitable.


### 3.2. how to creat a host database?
(1) download the host's genomic with *.fasta format.

(2) creat the host database using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), for example,
 ```bowtie2-build /path/human_hg38_refMrna.fna /path/human_hg38_refMrna```.
Then, the path ```/path/human_hg38_refMrna``` is filled in ```<database name="hostdb">``` section of file ```profiles.xml```. 

<b>Note, different samples may come from different hosts, please adjust them in time.</b>

### 3.3. how to creat a viral nr database?
(1) download the refseq sequence of viral nr from [NCBI](https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/).

(2) creat the viral nr database using [diamond](https://github.com/bbuchfink/diamond), for example, 
```diamond makedb -p 10 --in /path/protein.fasta --db /path/protein.dmnd```. Then, the path ```/path/to/protein.dmnd``` is filled in ```<database name="viral_nr">``` of file ```profiles.xml```. 

<b>Note, the viral nr database generally does not need to be replaced in the short term.</b>

### 3.4. how to creat a viral taxonomy?
The viral taxonomy information is used to classfy viral reads, this repository provides the [species_information-2021-05-20.txt]() collected by ourselves. If you want to add information, please keep it in the same format.

<b>Note, the viral taxonomy file generally does not need to be replaced in the short term.</b>


## 4. Getting help
nextvirus is a command line interface program, users can get help documentation by entering ```nextvirus -h```  or ```nextvirus --help``` .
| Parameter | Description |
| --- | --- |
|-h, --help | show this help message and exit|
|-i1 LEFT | reads file(*.fq) using forward sequencing.|
|-i2 RIGHT | reads file(*.fq) using reverse sequencing.|
|-xml PROFILES | the xml file with parameters of dependent software and databases.|
|-l LENGTH | the threshold of hit aa length used to filter the results of diamond, default: 10.|
|-s IDENTITY | the threshold of hit aa identity(%) used to filter the results of diamond, default: 20.|
|-e E_VALUE | three threshold of e-values are used to filter the sequence, default: 1e-6,1e-3,1e-1.|
|-r1 | run the sub-pipeline1 (reads → viral nr).|
|-r2 | run the sub-pipeline2 (reads → contigs → viral nr).|
|-t THREAD | number of used threads, default: 1.|
|-o OUTDIR | output directory to store all results.|


## 5. Example of usage

```
nextvirus -i1 reads_R1.fq -i2 reads_R2.fq -xml profiles.xml -r1 -r2 -t 8 -o outdir
```







