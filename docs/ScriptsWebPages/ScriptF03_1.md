---
layout: default
title: F03_1 - Combine Tables, Only Relevant Columns
parent: Scripts
nav_order: 304
---

<!-- # Reacheed snippet 2 and stopped proof-reading <- had this in the front matter as a comment-line. Suspect it may have caused an issue with jekyll/Liquid.  -->

## F03_1 - Combine Tables, Only Relevant Columns  
{: .fs-6 .text-center .fw-700 .lh-default }

---

<div markdown="1" >

{: .ghrepo-callout }
Find this script at [this Github repo].

[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts 

</div>

## Script Name:
{: .fs-4 .lh-default .mb-4 }

F03_1_AddZYYMM_RemvIrrelevCols_CombnCsvTbls

## Input:
{: .fs-4 .lh-default .mb-3 }

<!-- image(s) here? -->

The output of `F02_1_GetInitCsvTbls`, and also the output of `F02_2_Get_FNmeZYYMM_Rcrd` for file-name to 0.YYMM lookups. (See Preview Snippet 1 below.)  

<!-- TODO = make "Preview Snippet 1" an internal reference/link. -->

## Output:
{: .fs-4 .lh-default .mb-3 }

A single table, made from all of the statements' tables vertically stacked/combined.

CSV files (a.k.a. .csv files) are, of course, just text files. (I.e. What makes them CSV files is simply that each of its values are separated by a comma.[^extn_comment]) For this reason, our statements have initially been read-in as containing `type text` values. Thus, the output table's columns (excluding the columns that we generated - i.e. the source data's columns) are of `type text`.  

[^extn_comment]: Also of course, saving a file with the ".csv" extension does not necessarily make the file a CSV file (as defined above). E.g. Saving a file with that extension, does not cause some cross-check which verifies that the file contains text values that are separated by commas.

Shortly, script F03_3 will typecast the appropriate columns to `type number` and `type date`.

<!-- 
<div markdown="1" class="scrolling-div-class">
![Output table](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/06-XChecked_Output-166w49h.jpg){: .img-noloadingppty width="166px" height="49px" style="aspect-ratio:166/49;" }
</div>
--> 

## Observations:
{: .fs-5 .lh-default }


Thanks to our prior work, this script gets a lot done using relatively little code.  

What we've really produced so far is the `[Content]` column, which holds our 'real data', and a few some other columns (i.e. `[Name]`, `[HasX29Cols]`, `[Total_Rows]`, and we could easily add in a `[Z_YYMM]` column as well, via our lookup-record).

Those other columns have been obtained to improve the efficiency with which we process the `[Content]` column. Specifically, the efficiency of combining the `[Content]` column's cells into a single table.  
Once we have that combined table, we've finally completed the ostensibly simple task of vertically stacking each of the statements' tables.  

As such, that single table will be *the* subject for further processing, and we'll have no further need for the tables, lookup-records, etc. produced by prior scripts. This is desirable because it's generally more efficient to work with a single large table, than with many smaller tables.[^re_lazy]  
For example, if we want to apply the `Text.Upper` function to our `[Type]` column, then in the single-large-table case, a single call of `Table.Transform` is all that's required. However, in the many-smaller-tables case, we'd need that same/similar `Table.Transform` code, but we'd also need something like a list of all the small-tables, and to use `List.Transform` to separately apply that `Table.Transform` operation to each of the small-tables.

[^re_lazy]: Lazy evaluation's efficiency somewhat flies in the face of this suggestion that 'a single large iteration is better than repeated small iterations.' In the sense that lazy evaluation is about not 'doing' any of our iteratively-applied (or otherwise applied) operations until a value is actually needed.  
    E.g. When we specify/command for a transformation to be iteratively applied (e.g. for `Number.FromText` on the `[Amount]` column), PQFLang's laziness indeed means that it doesn't cause a whole text-column to be loaded into memory & CPU-cache, and a whole number-column to be created. *However,* it *does* cause the whole text-column to be transformed from a column of such instructions/pointers, to a column of the same instructions/pointers with one further instruction added. And so, even in a lazy evaluation context, our instruction-building process is analogous to eager evaluation, and so a single large iteration is still our preference.  
    Also, obviously a single large iteration isn't desirable if it's so large that it'd max-out our RAM (which could be solved by batching/partitioning). And implicitly, we're not referring to such a case.




## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }


<div markdown="1" class="scrolling-div-class mt-4">
![Source Tbl](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/01-ZYYMM_Added-FULLIMG-835w75h.jpg){: .img-lazy width="835px" height="75px" style="aspect-ratio:835/75;" }
{: .my-1 }
</div>

<br>

<div markdown="1" class="scrolling-div-class mt-4">
![Source Tbl](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/01-ZYYMM_Added-NEWCOL-338w74h.jpg){: .img-lazy width="338px" height="74px" style="aspect-ratio:338/74;" }
{: .my-1 }
</div>

1. `ZYYMM_Added`: As mentioned on F02_2's webpage, the file-names and 0.YYMM values contain the same information in the sense that they both uniquely identify a statement. Thus, it's extravagant to keep both columns in a table (unless we have another use for file-name).  
   However, if a debugger wants to inspect/open a file, clearly the filename is going to be more useful than its 0.YYMM value. Similarly, if there's been a mistake such as `02_BikeWorks_Aug26_TRR.csv` being misnamed, because it's actually (a duplicate of) July 2026's statement, then having both `[Name]` and `[Z_YYMM]` values side-by-side will be helpful to a debugger.
   Ergo we add a new `[Z_YYMM]` column, instead of transforming our `[Name]` column into a `[Z_YYMM]` column.  
   In fact, even more extravagantly, we even initially create/persist a `[Name]` column in our combined table. (Just in case, despite it being a fair bit further down the track, we still find it convenient for reference.)

<!-- ^ Query: Does "F02_2's webpage" still make that point? Accordingly, TODO: either delete that assertion, or make it a link to F02_2's webpage. -->


<!-- NB: I've also got a 01A-InOurCase-SortedCausesNoChange324w75h.jpg that isn't referred to. Do I need to add in a new dot-point??? -->


<div markdown="1" class="scrolling-div-class mt-7">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/02-LstOfSubTblColLsts_OnlyRelevs-98w240h.jpg){: .img-lazy width="98px" height="240px" style="aspect-ratio:98/240;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 1"}
2. `LstOfSubTblColLsts_OnlyRelevs`: This preview image shows a 2-item `list`, whose 2 items are also `lists`. And below it is a preview of the 1st item (i.e. the 1st nested `list`). And it shows us that the nested `list` contains further nested `lists`.
   I.e. This isn't a new concept. It's how our content `[Content]` already was. Initially, we knew the `list` cell-values contained either 29 or 28 nestes `lists`, depending on what version  of the statements (i.e. how old) we're dealing with. And the `[HasX29Cols]` column tells us which version we're dealing with.  
   However, we now process these `[Content]` cell values, so that we remove 7 columns. If we're dealing with a 28-column statement-version, these 7 columns include the 29th column of repeated `""`'s that our `Csv.Document` function created because we specified its columns parameter as 29.  
   The 7 columns are identified by position/order, and so the order differs based on what statement-version we're dealing with. Each of these sets of positions are stored in hardcoded variables (see e.g. `X28_Irrelevs` & `X29_Irrelevs`).  
   <br>  
   Because a relatively small number of items are being removed, we remove them using a recursive UDF called `Lst_RemovePsns`. If there was a longer list of items to be removed, a UDF that uses `List.Combine`, and extensively uses `List.Range`, and uses if-else logic to cover the cases where the 1st list item is/isn't the 1st item to be removed, would likely be more efficient. However, the recursive UDF is more readable, and appropriate for removing a small number of items.
   <br>  
   Further, using `List.Repeat`, and values from `[Name]`, `[Z_YYMM]`, and `[Total_Rows]`, we've also added in list representations of a `[Name]` and `[Z_YYMM]` column in/for each of the statements' tables.


<div markdown="1" class="scrolling-div-class mt-7">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/03-Matching_Col_Lsts-104w228h.jpg){: .img-lazy width="104px" height="228px" style="aspect-ratio:104/228;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 2"}
3. `Matching_Col_Lsts`: This preview image shows a `list`. It's a 22-item `list`, with the items corresponding to each statement-column remaining after those 7 irrelevant columns were removed. Accordingly, each item itself contains as many `lists` as there are files/statements that we're processing (which in this case/preview is 2 files).
   To achieve this we've used a zip-function (namely `List.Zip`). If 2 N-item data structures (e.g. `{'a', 'b', 'c'}` & `{'d', 'e', 'f'}`) are passed to a zip-function, then N 2-item data structures will be returned (i.e. `{% raw %}{{'a', 'd'}, {'b', 'e'}, {'c', 'f'}}{% endraw %}`). (This isn't a comprehensive description of zip functions, but surely gives the picture ...)


<div markdown="1" class="scrolling-div-class mt-7">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/04-FullTbl_ColsLst-104w265h.jpg){: .img-lazy width="104px" height="265px" style="aspect-ratio:104/265;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 3"}
4. `FullTbl_ColsLst`: This preview image shows a `list`. However, now each of its items are a `list` of scalar values, because its previous contents of each file's column x, has now been concatenated by `List.Combine`.


<div markdown="1" class="scrolling-div-class mt-7">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/05A_MostlyTxtCols_Tbl-EXTRACT-1116w144h.jpg){: .img-lazy width="1116px" height="144px" style="aspect-ratio:1116/114;" }
{: .my-1 }
</div>

<div markdown="1" class="scrolling-div-class">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_1/05B_MostlyTxt-AllColNames-190w513h.jpg){: .img-lazy width="190x" height="513px" style="aspect-ratio:190/513;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 4"}
5. `MostlyTxtCols_Tbl`: This preview image shows a `table`. We've hardcoded in the `type table` of this table (see `rowTyp`), which includes the column header info/data. 
   As mentioned earlier, most of the columns are of `type text`, and this is as per our hardcoded `type table` type (i.e. `rowTyp`). And is consistent with how the data has initially been read-in. 

---

