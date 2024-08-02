---
layout: default
title: F02_1 - Read-In Each Statements' Table 
parent: Scripts
nav_order: 302
---

# Reading-In Each Statements' Table  
{: .fs-6 .text-center .fw-700 .lh-default }

Conspicuously, we're yet to see a statement's 'real data' - i.e. their main table containing transaction records.  
This script 'reads in' the statements, by transforming our files' `type binary` values into `type table` values that correspond to the part of the file that contains the main table (i.e. corresponding to line 7 onwards).  
Additionally, a few transformations are applied to those tables.[^processing]  
Finally, those tables are then transformed into a `list` that contains a `list` for each column of the table.

[^processing]: Namely: (i) filtering on Column10 / the Status column for only rows that are "Settled" (i.e. not "Pending"); (ii) Adding a top-level column that stores the statement's total rows (i.e. total "Settled" rows); and (iii) adding a 0,1,2,... index column to each statement's table. 

---

<div markdown="1" class="ghrepo-topdiv">

{: .ghrepo-callout }
Find this script at [this Github repo].


[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts

</div>

## Script Name:
{: .fs-4 .lh-default .mb-4 }

F02_1_GetInitCsvTbls

## Input:
{: .fs-4 .lh-default .mb-3 }

The output of `F01_FolderProcessing`. (See 1st Preview Snippets step below.)  


## Output: 
{: .fs-4 .lh-default .mb-3 }

A table with rows like the following:
{: .mb-1 }

<div markdown="1" class="scrolling-div-class">
![Output table](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_1/04-Tbls_Tformd_2nd-675w222h.jpg){: .img-noloadingppty width="675px" height="222px" style="aspect-ratio:675/222;" }
{: .my-1 }
</div>

Clearly, most of the work that this script does is in how the values of the `[Content]` column have gone from being a pointer to a statement's file, to a `list` of `list`s.
{ .mt-1 }


## Observations:
{: .fs-5 .lh-default }

Especially invisible in the above output-image, is that the script adds its own index/sequence column to each statement's table.  
Such indexing / unique-identifier-columns aren't relevant to our immediate task of providing a concise summary-table to our accountants for their manual transaction-classifying. 

Instead, this is the first step towards ensuring that when the statements are all combined into one table, each row will have a unique identifier.  
Having a unique identifier will be vital to the database system/schema that will enable us to ultimately produce financial statements.

## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }

<div markdown="1" class="scrolling-div-class mt-4">
![Input Source](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_1/01-Source-519w263h.jpg){: .img-lazy width="519px" height="263px" style="aspect-ratio:519/263;" }
{: .my-1 }
</div>

{:style="counter-reset:none"}
1. `fldrinfo_tbl`: This is familiar from the `F01_FolderProcessing` script. This image has specifically selected a preview of the value of the `[Content]` column's 1st row. As we can see, it's the statement's actual file.


<div markdown="1" class="scrolling-div-class mt-7">
![Init Tbls Read-In](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_1/02-Tform2ColOfCSVs_s_Tbls-516w221h.jpg){: .img-lazy width="516px" height="221px" style="aspect-ratio:516/221;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
2. `Tform2ColOfCSVs_s_Tbls`: Again, the 1st value of the `[Content]` column is also selected for preview, and we can see that each of the `[Content]` cells now contain a `type table` value (no longer a `type binary` value).  
   However, this image doesn't reveal that we've also filtered our data. As mentioned previously, for each transaction, our TRR's first record a row with a Status-column of "Pending", and then later recording a row with a "Settled"/"Cancelled" Status-column. Obviously we're only interested in the settled transactions, and a corresponding filter approximately halves our initial data.  
   Even with PQFLang's lazy-evaluation on our side, the computational expense of data-processing varies according to the size of the data. Therefore, expediting this filtering operation significantly improves our efficiency.


<div markdown="1" class="scrolling-div-class mt-7">
![Get Total Rows](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_1/03-Add_TotalRows_Col-NEWCOL-347w73h.jpg){: .img-lazy width="347px" height="73px" style="aspect-ratio:347/73;" }
{: .my-1 }
</div>

{:style="counter-reset:none"}
3. `Add_TotalRows_Col`: Now that we've got a `type table` object for each statement, we can use it to get the total[^total] number of rows in each statement.  
   Again not evident from the image, to get the row-totals, our script decided to apply its own UDFunc,[^UDFunc] rather than use PQFLang's built-in `Table.AddColumn` function.  
   This is being pedantic, and may actually be less efficient, since the `Table.AddColumn`-method involves only a single call of a built-in function.  
   The rationale is that, (just like `Table.SelectRows`) `Table.AddColumn` requires us to provide it a function (usually a UDFunc) that receives a *whole* table-row as its only argument. Thus, even though PQFLang is lazy, and so the table-row's `record` only contains mere pointers to the cells'/record's values until those values are needed, `Table.AddColumn` *still* involves working with larger data than is necessary for our task (which only depends on the `[Content]` column).  
   We could get our row totals by simply applying `Table.TransformColumns` to the `[Content]` column. However, unsurprisingly, even after getting each statement's row-count, we still want to make use of the statement's table (i.e. the original `[Content]` column value).  
   Accordingly, this script copies the `[Content]` column into a new column, namely, `[Total_Rows]`. Being a copy-operation (i.e. no computations/transformations/evaluations required) this should be a cheap operation. And *then* we apply a simple `Table.RowCount` transformation to that column (i.e. applied via `Table.TransformColumns`).  
   In a way, `Table.TransformColumns` is similar to `Table.AddColumn`, *except* instead of requiring our UDF to receive a whole table-row, it requires our UDF to receive a single column-value. Thus, the `Table.TransformColumns` iterates over a much more simple and lightweight data-structure, which assumedly will equate to improved efficiency (despite our code taking up more lines than the `Table.AddColumn`-approach).

[^total]: Of course, we only want the total number of *relevant* rows, thus we're only counting the rows after the `[Status]="Settled"` filter has been applied.

[^UDFunc]: Using "UDFunc" as an abbreviation of User-Defined Function.

<div markdown="1" class="scrolling-div-class mt-7">
![Output table](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_1/04-Tbls_Tformd_2nd-CHANGE2Lists-286w73h.jpg){: .img-lazy width="286px" height="73px" style="aspect-ratio:286/73;" }
{: .my-1 }
</div>

{:style="counter-reset:none"}
4. `Tbls_Tformd`: Our final step performs two operations. (1) It adds a from-0 index column to each of the `[Content]` column's table values. (2) It then transforms each `[Content]` column value from a `type table` value to a `type list` value.  
   More specifically, each table column is transformed into a `list`, and then all those `list`s are wrapped/enclosed in another `list`.  
   Apparently, in order to combine our statements' tables, we're planning to combine each corresponding column's lists, and then construct the combined-table from the `{combod_col1s_List, combod_col2s_List, ...}` `list` value.  
   This may seem complex and convoluted compared to simply stacking each of our initial `type table` values on top of each other. However, the motivation should become clearer as additional columns are added to the tables.[^motivn]

[^motivn]: Especially when wanting to add a single constant value to each statement's table, (albeit a table represented by a list) but a different value for each statement's table. E.g. If wanting to add the file-name to a statement's table, then we can efficiently generate the list for that column via `List.Repeat`.
    Surely such column-construction is more efficient than e.g. `Table.AddColumn(TblVal, row_rcrd => "03_BikeWorks_Sep26_TRR", type text)`, which receives a redundant row-`record` argument for each row. Just as described in the `Table.AddColumn` discussion of the 3rd/`Add_TotalRows_Col` preview snippet.

---


