# owl-trainer

<img src="https://user-images.githubusercontent.com/63527442/205575870-8f68f194-9c8d-4dfe-ac31-db369adcaf51.jpg" width="250">

---

# Project Title: Overwatch Exploratory Data Analysis in R

## Executive Summary
Provide a brief overview of your project's objectives, key findings, and conclusions. This section should be concise and give a clear picture of what the project is about and what it achieved.

## Introduction
- **Background**: Offer context or background for the research question or problem.
- **Purpose**: State the purpose of your exploratory data analysis.
  1. Classify and predict hero class.
  2. Classify and predict event outcome.
  3. Classify and predict player score.
- **Research Questions**: List the research questions or hypotheses you are exploring.
  1. What is the relationship between skill level/rank and score?
  2. What is the relationship between result and score?
  3. What is the relationship between game_length and score?
- **Hypothesis Testing**: Perform hypothesis testing.
  1. H<sub>0</sub>: Grand Master Elimination/Death Ratio = $\mu$; H<sub>A</sub>: Grand Master Elimination/Death Ratio > $\mu$.
  2. H<sub>0</sub>: Grand Master Damage/Heal/Mitigation = $\mu$; H<sub>A</sub>: Grand Master Damage/Heal/Mitigation > $\mu$.

## Table of Contents
- [Executive Summary](#executive-summary)
- [Introduction](#introduction)
- [Installation and Setup](#installation-and-setup)
- [Codebook](#codebook)
- [Data Collection Method](#data-collection-method)
- [Usage](#usage)
- [Results and Discussion](#results-and-discussion)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Installation and Setup

Detailed instructions on how to set up the project. Include:
- Requirements (e.g., R version, additional software).
- Instructions to install R and RStudio, if necessary.
- Steps to clone the repository and set up the environment.
- Any required R packages and how to install them.

```bash
# Example commands to set up the environment

```

## Codebook

Detail the structure and explanation of the data:

|Variable |Description  |Type |Format/Units |
|---------|-------------|-----|-------------|
|control_no|  | | |
|map_name | | | |
|comp | | | |
|result | | | |
|final_score  | | | |
|game_mode  | | | |
|game_length  | | | |
|team | | | |
|elimination  | | | |
|assist | | | |
|death | | | |
|damage | | | |
|heal | | | |
|mitigation | | | |

- **Session Info**:
```plaintext
R version 4.3.2 (2023-10-31 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 11 x64 (build 22631)
```
- **Variables**: Description of each variable in the data set.
- **Formats or scales used**: Specify units of measurement, categorizations, or scales used.
  - **Data Types**:
    - **game_mode**: hybrid, payload, control
      - **final_score**: Attacker-Defender
    - **game_mode**: push
      - **final_score**: Maximum 1 point
- **Data Source**: Mention the original source of the data.

- **Packages**:
- **Libraries**:

## Data Collection Method

- **Data Source**: Explain where and how you collected the data.
  - **Data Storage**: Local SSD
  - **Data Format**: *.png
  - **Data Size**: 4.18 GB
- **Data Collection Process**: Describe the steps or methodology used in data collection.
  - **Collection Method 1**: Post game match scoreboard 
  - **Collection Method 2**: In-game menu career history 
- **Data Processing**: Outline any processing or cleaning done on the data.
  - **Pre-processing**: Filter incomplete/missing/NA player scores and match point results

## Usage

Instructions on how to run the analysis:
- Steps to load the data into R Studio.
- How to run analysis scripts.
- Any necessary instructions for interpreting the results.

```r
# Example code snippet
```

## Results and Discussion

- **Findings**: Summarize the key findings of the analysis.
- **Visualizations**: Include plots or graphs with appropriate captions.
- **Interpretation**: Discuss the implications or significance of the findings.

## Contributing

Guidelines for how others can contribute to your project. This might include:
- Instructions for submitting issues or questions.
- How to propose enhancements or fixes.

## License

This project is currently unlicensed. All rights reserved. Please feel free to contact for permissions to use, modify, or distribute the code in this repository until a license is designated.

## Contact

Provide contact information for further inquiries or collaboration.

- Email: [ddxbugs@proton.me](mailto:ddxbugs@proton.me)
