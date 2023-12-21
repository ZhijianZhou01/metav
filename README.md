# nextvirus: rapid identifying and classifying viral reads from high-throughput sequencing (illumina).

![](https://img.shields.io/badge/System-Linux-green.svg)
![](https://img.shields.io/pypi/wheel/virusrecom)


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
In order to manage the path and parameters of dependent softwares convenienty, the ```profiles.xml``` file is used to record their configuration. 

In general, paths and parameters of software only need to be configured once in the first running, except for the host database used to filter contamination of host genome.

### 3.1. about profiles.xml
the template of profiles.xml is provided in the github repository, please note,

+ currently version of nextvirus only supports Illumina platform.
  
+ the paths of these software and databases need to be adjusted with reference to your computer. 
  
+ the parameters of software in this profiles.xml.xml file generally does not need to be modified because they are suitable.


### 3.2. how to creat a host database?
(1) download the host's genomic with *.fasta format.

(2) creat the host database using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), for example,
 ```bowtie2-build /home/zzj/host_genome.fna /home/zzj/host_genome```.

(3) finally, fill the path ```/home/zzj/host_genome```  into ```<database name="hostdb">``` section of file ```profiles.xml```. 

(4) nextvirus supports multiplehost database, please use ```,``` to separate them, for example ```/home/zzj/host_genome1, /home/zzj/host_genome2```.

<b>Tip</b>, different samples may come from different hosts, please adjust them in profiles.xml in time.

### 3.3. how to creat a viral nr database?
(1) download the refseq sequence of viral nr from [NCBI](https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/).

(2) creat the viral nr database using [diamond](https://github.com/bbuchfink/diamond), for example, 
```diamond makedb -p 10 --in /home/zzj/nr/protein.fasta --db /home/zzj/nr/protein.dmnd```. 

(3) finally, fill the path ```/home/zzj/nr/protein.dmnd```  into ```<database name="viral_nr">``` section of file ```profiles.xml```. 


<b>Tip</b>, the viral nr database generally does not need to be replaced in the short term.

### 3.4. how to creat a viral taxonomy?
The viral taxonomy information is used to classfy viral reads, this repository provides the [taxonomy_information_2021-05-20.txt]() made by ourselves. If you want to add some information, please keep it in the same format. 
<b>Note</b>, the accession of protein needs to be consistent with viral nr database in the section 3.3.

<b>Tip</b>, the viral taxonomy file generally does not need to be replaced in the short term.


## 4. Getting help
nextvirus is a command line interface program, users can get help documentation by entering ```nextvirus -h```  or ```nextvirus --help``` .
| Parameter | Description |
| --- | --- |
|-h, --help | show this help message and exit|
|-pe | paired-end sequencing.|
|-se | single-end sequencing.|
|-i1 FORWARD | forward reads(*.fq) using paired-end sequencing.|
|-i2 REVERSE | reverse reads(*.fq) using paired-end sequencing.|
|-u UNPAIRED | reads file using single-end sequencing (unpaired reads).|
|-q QUALITIES | the qualities(phred33 or phred64) of sequenced reads, default: phred33.|
|-xml PROFILES | the *.xml file with parameters of dependent software and databases.|
|-len LENGTH | threshold of length of aa alignment in diamond, default: 10.|
|-s IDENTITY | threshold of identity(%) of alignment aa in diamond, default: 20.|
|-e E_VALUE | specify three e-values threshold used to filter the output of diamond, default: 1e-6,1e-3,1e-1.|
|-r1 | run the sub-pipeline1 (reads → viral nr).|
|-r2 | run the sub-pipeline2 (reads → contigs → viral nr).|
|-t THREAD | number of used threads, default: 1.|
|-o OUTDIR | output directory to store all results.|


## 5. Example of usage


+ if paired-end sequencing:
  
```
nextvirus -pe -i1 reads_R1.fq -i2 reads_R2.fq -xml profiles.xml -r1 -r2 -t 8 -o outdir
```

+ if single-end sequencing:
 
 ```
nextvirus -se -u reads.fq -xml profiles.xml -r1 -r2 -t 8 -o outdir
```

<b> Tip </b>
+ nextvirus is also supported to run one of ```-r1``` and ```-r2``` alone.

+ if ```-r2``` is used, the output directory behind ```-o``` have to be <b>absolute path</b>.

+ if an error is displayed, check whether the parameters are entered correctly or XML file is correctly configured.


## 6. Output results
+ file ```input-parameter.txt```, which contains the used parameters of nextvirus in command-line interface.
+ directory ```pipeline1```, which contains intermediate results and ```finally_result``` from sub-pipeline1(reads → viral nr).
+ directory ```pipeline2```, which contains intermediate results and ```finally_result``` from sub-pipeline2(reads → contigs → viral nr).




