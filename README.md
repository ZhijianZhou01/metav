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
In order to manage the path and parameters of theses dependent software convenienty, the ```xml``` file is used to record the their configuration.

A template (profiles.xml) is provided in the github repository, and the content is as follows.

```
<?xml version="1.0" standalone="yes"?>


<!--

the running of nextvirus depends on the following software (app) and databases, and you need to prepare them in advance on your computer.
In general, paths and parameters of software only need to be configured once in the first running, except for the host database used to filter contamination.

Below is an example, please note:
(1) currently version of nextvirus only supports the processing of paired-end sequencing data from Illumina platform.
(2) the paths of these software and databases need to be adjusted with reference to your computer.
(3) the parameters of software in this *.xml file generally does not need to be modified because they are suitable.

-->
 

<dependencies>
	<!-- the path and parameters of bowtie2 (double-ended sequencing) -->
	<app name="bowtie2">
		<path>
		/home/zzj/software/bioinfo/bowtie2/bowtie2
		</path>
		<parameter>
		--very-sensitive --dovetail
		</parameter>
	</app>

	<!-- the path and parameters of trimmomatic (double-ended sequencing) -->
	<app name="trimmomatic">
		<path>
		/home/zzj/software/bioinfo/trimmomatic/trimmomatic
		</path>
		<parameter>
		ILLUMINACLIP:/home/zzj/software/bioinfo/trimmomatic/adapters/merge_adapter.fas:2:40:15:8:true LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50
		</parameter>
	</app>


	<!--  the path and key parameters of Trinity -->
	<app name="Trinity">
		<path>
		/home/zzj/software/bioinfo/trinity/trinityrnaseq-v2.15.1/Trinity
		</path>
		<parameter>
		--max_memory 50G
		</parameter>
	</app>


	<!--  the path and key parameter of diamond program, note, the e-value is fixed at 1.  -->
	<app name="diamond">
		<path>
		/home/zzj/HTS/diamond_data/diamond
		</path>
		<paremeter>
		--max-target-seqs 1 -b5 -c1 --outfmt 6 qseqid sseqid stitle bitscore pident nident evalue gaps length qstart qend sstart send
		</paremeter>
	</app>


	<!-- the path of host database which was created in advance by bowtie2-build program, and usually needs to be adjusted. -->
	<!-- for example: bowtie2-build /path/Human_Gallus_gallus.fas /path/Human_Gallus_gallus -->
	<database name="hostdb">
		<path>
		/home/zzj/HTS/host_db/Human_Gallus_gallus_db/Human_Gallus_gallus
		</path>
	</database>


	<!-- the path of viral nr database (*.dmnd), which was created in advance by diamond program. -->
	<database name="viral_nr">
		<path>
		/home/zzj/HTS/diamond_data/ViralProtein.dmnd
		</path>
	</database>


	<!-- the path of information of viral taxonomy.  -->
	<taxonomy name="viral_taxonomy">
		<path>
		/home/zzj/HTS/diamond_data/species_information-2021-05-20.txt
		</path>
	</taxonomy>


</dependencies>

<!--  note, the software and databases dependencies needs to be installed manually in advance.  -->

```


