# Metagenomics virus detection (MetaV): rapid detection and classification of viruses in metagenomics sequencing


![](https://img.shields.io/badge/System-Linux-green.svg)
![](https://img.shields.io/pypi/wheel/metav)
![](https://img.shields.io/pypi/dm/metav)

## 1. Introduction
### 1.1. workflow of metav
metav is a command-line-interface program, which is used to rapidly identify and classify viral sequences from metagenomic sequencing data. metav is developed via `Python 3`, and can be run on Linux systems and deployed to the cloud. 

The workflow of metav is simple but efficientas,

<div  align="left">    
<kbd><img src="https://github.com/ZhijianZhou01/metav/blob/main/figure/metav.jpg" width = "532" height = "552" alt="work" align=left /></kbd>
</div>


### 1.2. Functional expansion
metav was originally designed to detect and count the viral composition in metagenomics-sequencing-data, but it's flexible and not limited to viruses.

In fact, the viral nr database can be replaced by protein databases of other pathogenic, for example, bacteria, pathogenic fungi. These nr database cam be download from [database of ncbi refseqs](https://ftp.ncbi.nlm.nih.gov/refseq/release/). In a word, metav can detect and count other pathogens of metagenomics-sequencing-data by using the corresponding nr database and taxonomy information file.

## 2. Download and install

### 2.1. conda method (recommend)
metav has been distributed to the `conda` platform (https://anaconda.org/bioconda/metav), and conda will automatically resolve software dependencies (including [Trimmomatic](https://anaconda.org/bioconda/trimmomatic), [Bowtie2](https://anaconda.org/bioconda/bowtie2), [Trinity](https://anaconda.org/bioconda/trinity) and [diamond](https://anaconda.org/bioconda/diamond)). Thus, we recommend installing metav using `conda`.
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

# (3) view the help documentation
metav -h
```

<b>Note: </b> the dependent `salmon` software will not be installed properly by conda, and you need reinstall it.
```
# (1) look at the path of the installed salmon
which salmon
# such as: /home/zzj/anaconda3/envs/metav_env/bin/salmon

# (2) remove the wrong installation
rm /home/zzj/anaconda3/envs/metav_env/bin/salmon

# (3) reinstall salmon
sudo apt install salmon
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

+  [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) (version >=0.39), which is used to remove the contamination from adapter primer.

+  [Bowtie2](https://github.com/BenLangmead/bowtie2/releases) (version >=2.3.0), which is used to remove the contamination from host genome.
  
+  [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) (version >=2.15.1), in the second sub-pipeline of `metav`, the Trinity is used to splice reads to contigs. <b>Note</b>, the running of Trinity relies on [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), [jellyfish](https://github.com/gmarcais/Jellyfish/releases), [samtools](https://github.com/samtools/samtools/releases) and [salmon](https://github.com/COMBINE-lab/salmon/releases/), and they can be easily installed,
```
# (1) bowtie2 
sudo apt-get install c

# (2) jellyfish
sudo apt-get install jellyfish

# (3) salmon
sudo apt install salmon

# (4) samtools
wget https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2
tar -zxvf samtools-1.20.tar.bz2
cd samtools-1.20
./configure
make
make install
```

+  [diamond](https://github.com/bbuchfink/diamond) (version >=2.0.9), the diamond is used to map reads (or contigs) to  proteins.

<b>Note, if metav is installed by `pip` method or using `binary file`, the four dependencies (Trimmomatic, Bowtie2, Trinity and diamond) need to be installed manually by users in advance and be added to `PATH` (system or user)</b>. 

##  4. Database dependencies
### 4.1. prepare host database

The host database is used to remove contamination from host genome. <b>How to prepare a host database?</b>

(1) download the genomic data of host with *.fasta format.

(2) creat the host database using [Bowtie2](https://github.com/BenLangmead/bowtie2/releases) software, for example,
 `bowtie2-build /home/zzj/host_db/host_genome.fna /home/zzj/host_db/host_genome`. It then generates six files, which starts with "host_genome" and suffix are '.1.bt2', '.2.bt2', '.3.bt2', '.4.bt2', '.rev.1.bt2', and '.rev.2.bt2'.

<b>Next</b>, you need to fill in the path `/home/zzj/host_db/host_genome` into file `profiles.xml`. <b>Note</b>, the path `/home/zzj/host_db/host_genome` is not a directory!


(3) metav also supports multiplehost databases, please use `,` to separate these path in file `profiles.xml`, for example, `/home/zzj/host_db/host_genome1, /home/zzj/host_db/host_genome2`.

<b>Tip</b>, different samples may come from different hosts, please adjust them in file `profiles.xml` in time.

### 4.2. prepare viral nr database

The viral nr database was used to identity viral components from sequenced reads. <b>How to prepare a viral nr database?</b>

(1) firstly, download the refseqs of viral proteins (amino acid, `*.1.protein.faa.gz`) from [viral database of ncbi refseqs](https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/), besides, please also download `*.protein.gpff.gz` containning the taxonomic information of these sequences. <b>Note</b>, the format of file `*.1.protein.faa.gz` is `fasta`.

(2) next, unzip `*.1.protein.faa.gz` and rename to `ViralProtein.fasta`, then creat the viral nr database using [diamond](https://github.com/bbuchfink/diamond) software, for example, 
`diamond makedb -p 10 --in /home/zzj/nr/ViralProtein.fasta --db /home/zzj/nr/ViralProtein.dmnd`. Then, fill in the path `/home/zzj/nr/ViralProtein.dmnd` into file `profiles.xml`.

(3) then, extract the viral taxonomy information from file `*.protein.gpff.gz` , which is used to classfy viral reads. This repository provides the [taxonomy_information](https://github.com/ZhijianZhou01/metav/releases/tag/data) made by ourselves, in which the accession is consistent with the file `ViralProtein.fasta`. If you want to add some information, please keep it in the same format (four columns, don't change the name of column). Finally, fill in the path of taxonomy information file into the file `profiles.xml`.

<b>Tip</b>, the viral nr database generally does not need to be replaced in the short term.



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
|-len LENGTH | threshold of length of aa alignment in diamond, default: 10.|
|-s IDENTITY | threshold of identity(%) of alignment aa in diamond, default: 20.|
|-e E_VALUE | specify three e-values threshold used to filter the reads (or contigs) hit nr database, default: 1e-6,1e-3,1e-1.|
|-r1 | run the sub-pipeline 1 (reads → nr database).|
|-r2 | run the sub-pipeline 2 (reads → contigs → nr database).|
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

+ if `-r2` is used, the output directory behind `-o` have to be <b>absolute path</b>.

+ if an error is displayed, please check the input parameters and XML file.


## 8. Output results

### 8.1. input-parameter.txt

the output file `input-parameter.txt` recorded the input parameters in command-line interface.

```
the used parameters of metav in command-line interface.

pair_end:	True
single_end:	False
sub-pipeline 1:	True
sub-pipeline 2:	True
forward_reads:	/home/zzj/datas/test/reads_1.fq
reverse_reads:	/home/zzj/datas/test/reads_2.fq
unpaired:	None
qualities:	phred33
set_file:	/home/zzj/datas/test/profiles.xml
length_threshold:	10.0
identity_threshold:	20.0
e-value:	['1e-6', '1e-3', '1e-1']
thread:	8
outdir:	/home/zzj/datas/test/out6
```

### 8.2. directory pipeline1
the directory `pipeline1` contains intermediate results and `finally_result` from `sub-pipeline 1` (reads → nr database). 

In the example, three thresholds (`1e-6`, `1e-3` and `1e-1`) of e-value are used to filter the output diamond program. Thus, three corresponding sub-directories is created and used to store results. 
![https://github.com/ZhijianZhou01/metav/blob/main/figure/e-value.png](https://github.com/ZhijianZhou01/metav/blob/main/figure/e-value.png)

The meanings of directory name with e-value in `pipeline1` are as follows,

| sub-directories | description |
| --- | --- |
|lower_1e-6 | e-value of hit reads < `1e-6` |
|lower_0.001 | `1e-6` < e-value of hit reads < `1e-3` |
|lower_0.1 | `1e-3` < e-value of hit reads < `1e-1` |

The hierarchy is same in all three sub-directories with e-value. For example, in the directory `hit_summary` of the directory `lower_1e-6`, metav provides a summary file (`hit_reads_taxonomy_information.txt`) with taxonomy information. 

What's more, metav counts these hit reads according to `order`, `family` and `strain`(organism) and provides three `*.csv` summary files.

![https://github.com/ZhijianZhou01/metav/blob/main/figure/reads_summary.png](https://github.com/ZhijianZhou01/metav/blob/main/figure/reads_summary.png)

<b>In particular, metav extract all hit reads sequences (*fasta format) according to the hierarchical relationship of `order`, `family` and `strain`(organism)</b>. These hit reads sequences are stored in directory `hit_reads_seq`.


### 8.3. directory pipeline2
the directory `pipeline2` contains intermediate results and `finally_result` from `sub-pipeline 2` (reads → contigs → nr database). The hierarchy of the directory of output results is the same as directory `pipeline1`.

However, the output in directory `finally_result` of the directory `pipeline2` are hit contigs, not reads.

The meanings of directory name with e-value in `pipeline2` are as follows,

| sub-directories | description |
| --- | --- |
|lower_1e-6 | e-value of hit contigs < `1e-6` |
|lower_0.001 | `1e-6` < e-value of hit contigs < `1e-3` |
|lower_0.1 | `1e-3` < e-value of hit contigs < `1e-1` |

In the directory `hit_summary` of each sub-directory with e-value, the sequences and summary information of hit contigs are provided, and these hit contigs sequences are stored in directory `hit_contigs_seq`.

![https://github.com/ZhijianZhou01/metav/blob/main/figure/contigs_symmary.png](https://github.com/ZhijianZhou01/metav/blob/main/figure/contigs_symmary.png)


## 9. Application
metav has contributed to the discovery of many new pathogens, some of which have been published.

+ Chu KK, Zhou ZJ, Wang Q, Ye SB, Guo L, Qiu Y, Zhang YZ, Ge XY. Characterization of Deltacoronavirus in Black-Headed Gulls (Chroicocephalus ridibundus) in South China Indicating Frequent Interspecies Transmission of the Virus in Birds. <i>Front Microbiol</i>. 2022 May 12;13:895741. [doi: 10.3389/fmicb.2022.895741](https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2022.895741/full).

+ Shi Y, Tang H, Zhou ZJ, Liao JY, Ge XY, Xiao CT. First detection of Tetraparvovirus ungulate 1 in diseased cattle (Chinese Simmental) from Hunan province, China. <i>Virol J</i>. 2024. Jun 6;21(1):132. [doi: 10.1186/s12985-024-02402-1](https://virologyj.biomedcentral.com/articles/10.1186/s12985-024-02402-1).

+ Yu XW, Wang Q, Liu L, Zhou ZJ, Cai T, Yuan HM, Tang MA, Peng J, Ye SB, Yang XH, Deng XB, Ge XY. Detection and Genomic Characterization of Torque Teno Virus in Pneumoconiosis Patients in China. <i>Viruses</i>. 2024; 16(7):1059. [doi: 10.3390/v16071059](https://www.mdpi.com/1999-4915/16/7/1059).

+ Zheng JH, Zhou ZJ, Liao ZC, Qiu Y, Ge XY, Huang X. Prevalence and genetic diversity of Parechovirus. <i>Virus Res</i>. 2024 Nov;349:199461. [doi: 10.1016/j.virusres.2024.199461](https://www.sciencedirect.com/science/article/pii/S0168170224001540)


## 10. Cite

For example, `the viral (or other pathogens) reads/components were identified by metav pipeline (https://github.com/ZhijianZhou01/metav)`.

## 11. Bug report
metav was test on Ubuntu 16.04 and Ubuntu 20.02, which can work well. If you run into a problem or find a bug, please contact us.

[Github issues](https://github.com/ZhijianZhou01/BioAider/issues) or send email to zjzhou@hnu.edu.cn.
