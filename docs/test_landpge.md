---
layout: default
title: Landing Page
nav_order: 2
---

<!-- TODO - links to other pages -->

# Using Power Query To Process Bank Statements
{: .fs-9 }

## Purpose & Use-Case:
{: .fs-4 }

The scripts described here start from a folder of .csv files, and produce a table that's useful for the end user.

This is part of a larger process which aims to go from bank statements (i.e. the .csv files) to financial reports.  
Preferably, the process would be fully automated. If so, the above would instead describe 'producing data for further processing by the second part our process.' However, our pipeline/process does not know the cause of each bank transaction.

<!-- Going to try to make below fnote x2 lines just to see what happens -->
Therefore, this process is designed to output data for a human, not a computer.  
Specifically, we aim to assist a human who will record what financial account each bank transaction relates to.[^account_eg]

[^account_eg]: For example, a receipt might be allocated to the 'Sales' account.
Or a payment might be allocated to 'Electricity Expense.'

We're described as 'using Power Query,' because the scripts are written in Power Query Formula Language (a.k.a. M Code). Referred to as **PQFLang** in this website.  
<!-- ^ Link re PQFLang?? -->
PQFLang is used by the freely available Power BI Desktop, and ubiquitous (albeit premium) Excel. These programs are user-friendly, and so we envisage one of them producing this output for receipt by a human user.  
Notwithstanding, other programming languages and tools are probably better for this task. Especially, if we're not limited to using only free software.

## The Rest Of This Website:
{: .fs-4 }

If you're purely interested in the code, then you can jump straight to the Scripts section. Those pages provide directions to where the scripts are available from github.com, and also describe what a script does and how it does it.

<!-- Also want the Scripts section's landing page to describe being careful to not load any of the scripts in Excel or PBI -->

However, descriptions such as 'going from files to a useful table,' are abstract and lack context. The Context section aims to remidiate this.  
The Context page describes a hypothetical business, BikeWorks, and their fictional bank, Zairwallex. Thereby providing a a detailed picture of when these scripts might be useful.  
Meanwhile, the Bank Statement Data page goes into detail on how the bank statements work.

The bank statements are sufficiently intuitive that you can 'follow along' without prior knowledge of them. However, it will leave you making assumptions, or being unsure, about the data.  
For example, how do the 'Transaction Amount' and 'Settlement Amount' columns differ? Are the 'Created At' and 'Settled At' columns always populated, or are they sometimes empty?  

Accordingly, the Bank Statement Data page provides significant context. Further, it identifies the idiosyncratic challenges of working with our data.  
From my selfish perspective, it's nice for the reader to be aware of these challenges, otherwise they might conclude that the scripts are weirdly designed!

And that's it. A pane on the left-hand side of this webpage[^website] should be available for navigating between all of the webpages.

[^website]: Indeed, the same navigation pane should be available on all pages of this website.
