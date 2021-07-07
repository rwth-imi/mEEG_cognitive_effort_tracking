# Tracking of the cognitive load with a mobile EEG sensor

## Overview
This repository holds MATLAB scripts to perform pre-processing
and statistical analysis on EEG data in .edf format. The data is
taken from a study performed for tracking of the load of a mobile
EEG sensor ([Emotiv Epoc] (https://www.emotiv.com/epoc/), EMOTIV Inc., San Francisco, USA)).

## Requirements
-MATLAB (tested with 2019a)
-[EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)

## Before Start
Add the folder *functions* to MATLAB's path. Set the parameters and in
the file *globals.m*.

## Dataset
Read the *studyguide.pdf* to see details of the dataset structure
and the performed experiments.
Set the path to the dataset and further parameters in *globals.m*.

## Table Generation
Run the script *table_generation_all.m* to compute tables describing event-
related epochs and their statistical features. By default the tables are 
stored in the main directory of the repository.

## Statistical Analysis
After the tables have benn computed the remaining scripts in the main
directory of the repository can be executed for statistical analysis.

