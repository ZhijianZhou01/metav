# Metagenomics virus detection (MetaV): rapid detection and classification of viruses in metagenomics sequencing


![](https://img.shields.io/badge/System-Linux-green.svg)
![](https://img.shields.io/pypi/wheel/metav)
![](https://img.shields.io/pypi/dm/metav)

## 1. Introduction
metav is a command-line-interface program, which is used to rapidly identify and classify viral sequences from metagenomic sequencing data. metav is developed via `Python 3`, and can be run on Linux systems. 

The workflow of metav 2.x is is as follows:

<div  align="left">    
<kbd><img src="https://github.com/ZhijianZhou01/metav/blob/main/figures/workflow.png" width = "532" height = "552" alt="work" align=left /></kbd>
</div>


## 2. Download and install

### 2.1. conda method (recommend)
metav 2.x has been distributed to the `conda` platform (https://anaconda.org/bioconda/metav), and conda will automatically resolve software dependencies (including [trimmomatic](https://anaconda.org/bioconda/trimmomatic), [bowtie2](https://anaconda.org/bioconda/bowtie2), [megahit](https://anaconda.org/bioconda/megahit) and [diamond](https://anaconda.org/bioconda/diamond)). Thus, we recommend installing metav using `conda`.
```
# (1) add bioconda origin
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# (2) install metav
## (i) create a separate environment for metav (recommend)
conda create -n metav_env python=3.7  # python >=3.5
conda activate metav_env
conda install metav    # or 'conda install bioconda::metav'

## (ii) or installation without creating separate environment (slow)
conda install metav  # or 'conda install bioconda::metav'

# (3) Modify the maximum java memory for trimmomatic
Note, the default value(1Gb) of maximum java memory is not recommended, a lower value will prevent reads from being output properly.
For example, open the file "/home/zzj/anaconda3/envs/metav_env/share/trimmomatic-0.39-2/trimmomatic", use maximum memory of 20Gb and modify 'default_jvm_mem_opts = ['-Xms512m', '-Xmx1g']'  → 'default_jvm_mem_opts = ['-Xms512m', '-Xmx20g']'

# (4) view the help documentation
metav -h

```


### 2.2. pip method
metav has been distributed to the standard library of PyPI (https://pypi.org/project/metav/), and can be easily installed by the tool ```pip```.
```
pip install metav
metav -h
```
<b>Note, if metav is installed by `pip` tool, you also need to manually install the software dependencies, please see section 3.</b>

### 2.3. or using binary file
The binary file of metav (for linux system) can be downloaded from https://github.com/ZhijianZhou01/metav/releases. 

<b>Note that if you use the metav binary directly, you also need to manually install the software dependencies, please see section 3.</b>


## 3. Software dependencies

The running of `metav` relies on these softwares:

+  [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) (version >=0.39), which is used to remove the contamination from adapter primer. Note, the default value(1Gb) of maximum java memory is not recommended, a lower value will prevent reads from being output properly.
For example, open the file `/home/zzj/anaconda3/envs/metav_env/share/trimmomatic-0.39-2/trimmomatic`, use maximum memory of 20Gb and modify `default_jvm_mem_opts = ['-Xms512m', '-Xmx1g']`  → `default_jvm_mem_opts = ['-Xms512m', '-Xmx20g']`

+  [bowtie2](https://github.com/BenLangmead/bowtie2/releases) (version >=2.3.0), which is used to remove the contamination from host genome.
  
+  [megahit](https://github.com/voutcn/megahit) (version >=1.2.6), in the sub-pipeline 2 of `metav`, the megahit is used to splice reads to contigs.

+  [diamond](https://github.com/bbuchfink/diamond) (version >=2.0.9), the diamond is used to map reads (or contigs) to  proteins.

<b>Note, if metav is installed by `pip` method or using `binary file`, the four dependencies (Trimmomatic, Bowtie2, megahit and diamond) need to be installed manually by users in advance and be added to `PATH` (system or user)</b>. 

##  4. Database dependencies
### 4.1. prepare host database

The host database is used to remove contamination from host genome. <b>How to prepare a host database?</b>

(1) download the genomic data of host with *.fasta format.

(2) creat the host database using [Bowtie2](https://github.com/BenLangmead/bowtie2/releases) software, for example,
 `bowtie2-build /home/zzj/host_db/host_genome.fna /home/zzj/host_db/host_genome`. 

<b>Next</b>, you need to fill in the path `/home/zzj/host_db/host_genome` into file `profiles.xml`. <b>Note</b>, the path `/home/zzj/host_db/host_genome` is not a directory!

(3) metav also supports multiplehost databases, please use `,` to separate these path in file `profiles.xml`, for example, `/home/zzj/host_db/host_genome1, /home/zzj/host_db/host_genome2`.

<b>Tip</b>, different samples may come from different hosts, please adjust them in file `profiles.xml` in time.


### 4.2. prepare plasmids database

The plasmids database is used to remove contamination from plasmids. <b>How to prepare a plasmids database?</b>

(1) download the plasmids genomic sequences from https://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/.

(2) creat the plasmids database using [Bowtie2](https://github.com/BenLangmead/bowtie2/releases) software, for example,
 `bowtie2-build --threads 30 /home/zzj/database/plasmids/combined_plasmids_nt.fna /home/zzj/database/plasmids/combined_plasmids`. 

<b>Next</b>, you need to fill in the path `/home/zzj/database/plasmids/combined_plasmids` into file `profiles.xml`.

### 4.3. prepare viral nr database

The viral nr database was used to identity viral components from sequenced reads. <b>How to prepare a viral nr database?</b>

(1) firstly, download the refseqs of viral proteins from [viral database of ncbi refseqs](https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/)

```
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.protein.faa.gz
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.protein.gpff.gz
gunzip -k *.gz
diamond makedb -p 20 --in viral.1.protein.faa --db /home/zzj/database/viral_nr/ViralProtein.dmnd

```
<b>Next</b>, you need to fill in the path `/home/zzj/database/viral_nr/ViralProtein.dmnd` into file `profiles.xml`.


(2) build the viral taxonomy information
```
# run viral_taxonomy_information.sh in this repository

chmod –R 775 viral_taxonomy_information.sh
./viral_taxonomy_information.sh
```
<b>Next</b>, you need to fill in the path of file `viral_extracted_info.txt` into file `profiles.xml`.

This repository also provides the [taxonomy_information](https://github.com/ZhijianZhou01/metav/releases/tag/data) made by ourselves, in which the accession is consistent with the file `ViralProtein.fasta`. If you want to add some information, please keep it in the same format (four columns, don't change the name of column). Finally, fill in the path of taxonomy information file into the file `profiles.xml`.

<b>Tip</b>, the viral nr database generally does not need to be replaced in the short term.


### 4.4. prepare nr database

(1) download the data
```
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
gunzip -c nr.gz > nr.faa

wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
gunzip -c prot.accession2taxid.gz > prot.accession2taxid

wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
tar -xzf new_taxdump.tar.gz
```

(2) build the nr database with taxonomy information
```
diamond makedb --in nr.faa -d /home/zzj/database/nr/nr_taxid.dmnd \
--taxonmap prot.accession2taxid \
--taxonnodes nodes.dmp \
--taxonnames names.dmp \
--threads 20 \
--verbose

```
<b>Next</b>, you need to fill in the path of `/home/zzj/database/nr/nr_taxid.dmnd` into file `profiles.xml`.


## 5. Configuration of dependencies
In order to manage the parameters of dependent softwares and databases convenienty, the `profiles.xml` file is used to record their configuration. 

the template of `profiles.xml` is provided in the github repository, please note,

+ <b>currently version of metav only supports the sequenced data from `second-generation sequencing`</b>.
  
+ the paths of these databases in file `profiles.xml` need to be adjusted with reference to your computer, databases paths in `profiles.xml` we provided were just some examples. <b>Note, they have to be absolute path, not relative path.</b>
  
+ the parameters of software in `profiles.xml` generally does not need to be modified because they are suitable in most cases.
<b>But, note, the path of adapters file needs to be modified</b>, see field `ILLUMINACLIP:/home/zzj/anaconda3/envs/metav_env/share/trimmomatic-0.39-2/adapters/merge_adapter.fas` in setting of trimmomatic in `profiles.xml`. The path `/home/zzj/anaconda3/envs/metav_env/share/trimmomatic-0.39-2/adapters/merge_adapter.fas` here is only an example, adapter file is generally in the `adapters` folder of the installation directory of trimmomatic software, or you can make this file yourself, just fill in the corresponding absolute path here.

<b>Tip</b>, in general, these parameters only need to be configured once in the first running, except for the host database used to filter contamination of host genome.


## 6. Getting help
Users can view the help documentation by entering `metav -h`  or `metav --help` .
| Parameter | Description |
| --- | --- |
|-h, --help | show this help message and exit|
|-pe | paired-end sequencing.|
|-se | single-end sequencing.|
|-i1 FORWARD | forward reads (*.fq) using paired-end sequencing.|
|-i2 REVERSE | reverse reads (*.fq) using paired-end sequencing.|
|-u UNPAIRED | reads file using single-end sequencing (unpaired reads).|
|-q QUALITIES | the qualities (phred33 or phred64) of sequenced reads, default: phred33.|
|-xml PROFILES | the *.xml file with parameters of dependent software and databases.|
|-ne NR_E_VALUE | specify two e-values threshold used to retain viral hits and exclude non-viral hits using nr database, default: 0.1,1e-5.|
|-oe OUT_E_VALUE | specify three e-values threshold used to output the viral reads (or contigs) hit nr database, default: 1e-10,1e-5,1e-1.|
|-len LENGTH | threshold of length of aa alignment in diamond, default: 10.|
|-s IDENTITY | threshold of identity(%) of alignment aa in diamond, default: 20.|
|-r1 | run the sub-pipeline 1 (reads blastx [viral-nr and nr db]).|
|-r2 | run the sub-pipeline 2 (reads → contigs blastx [viral-nr and nr db]).|
|-t THREAD | number of used threads, default: 1.|
|-o OUTDIR | output directory to store all results.|


## 7. Example of usage

+ <b>if reads are from paired-end sequencing:</b>
  
```
metav -pe -i1 reads_R1.fq -i2 reads_R2.fq -xml profiles.xml -r1 -r2 -t 8 -o outdir
```

+ <b>if reads are from single-end sequencing:</b>
 
 ```
metav -se -u reads.fq -xml profiles.xml -r1 -r2 -t 8 -o outdir
```

<b> Tip </b>
+ metav is also supported to run one of `-r1` and `-r2`.

+ if an error is displayed, please check the input parameters and XML file.


## 8. Output results

### 8.1. input-parameter.txt

the output file `input-parameter.txt` recorded the input parameters in command-line interface.


### 8.2. directory reads_blast
the directory `reads_blast` contains intermediate results and `finally_result` from `sub-pipeline 1` (reads blastx [viral-nr and nr db]). 

If use `-oe 1e-10,1e-5,1e-1`, three thresholds of e-value are used to filter the output diamond program. The meanings of sub-directory name in the directory `finally_result` with e-value are as follows,

| sub-directories | description |
| --- | --- |
|lower_1e-10 | e-value of hit reads < `1e-10` |
|1e-10_1e-05 | `1e-10` < e-value of hit reads < `1e-5` |
|1e-05_0.1 | `1e-5` < e-value of hit reads < `1e-1` |

The hierarchy is same in all three sub-directories with e-value. In the directory `hit_summary` of each sub-directory with e-value, metav counts these hit reads according to `order`, `family` and `strain`(organism) and provides three `*.csv` summary files.

<b>In particular, metav extract all hit reads sequences (*fasta format) according to the hierarchical relationship of `order`, `family` and `strain`(organism)</b>. These hit reads sequences are stored in directory `hit_reads_seq`.


### 8.3. directory contigs_blast
The directory `contigs_blast` contains intermediate results and `finally_result` from `sub-pipeline 2` (reads → contigs blastx [viral-nr and nr db]). 

If use `-oe 1e-10,1e-5,1e-1`, The meanings of sub-directory name with e-value in the directory `finally_result` are as follows,

| sub-directories | description |
| --- | --- |
|lower_1e-10 | e-value of hit contigs < `1e-10` |
|1e-10_1e-05 | `1e-10` < e-value of hit contigs < `1e-5` |
|1e-05_0.1 | `1e-5` < e-value of hit contigs < `1e-1` |

In the directory `hit_summary` of each sub-directory with e-value, the sequences and summary information of hit contigs are provided, and these hit contigs sequences are stored in directory `hit_contigs_seq`.


### 9. Important Notes
+ As a pipeline that calls existing software, metav aims to reduce the complexity of switching between tools. During the blast step, it is difficult to avoid false positives hits, especially with reads. Therefore, the final output of metav requires further evaluation. For instance, applying additional filters based on the number of hit reads or performing alignment against reference genomes can help reduce false positives. Additionally, a more stringent e-value threshold can be set for blast, but it is also important to balance the risk of false negatives.

+ Not applicable to metatranscriptomic sequencing data.


## 10. Bug report
If you run into a problem or find a bug, please contact us.

[Github issues](https://github.com/ZhijianZhou01/metav/issues) or send email to zjzhou@hnu.edu.cn.
