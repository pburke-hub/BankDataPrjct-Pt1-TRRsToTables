---
layout: default
title: F02_2 - Get File-Name To 0.YYMM Records 
parent: Scripts
nav_order: 303
# Atm this file is too long for me to have time for a proper proof-read! Ideally, it can be whittled down. O/wise it looks stupidly long!
---

# Get `type record`s Of File-Name -> 0.YYMM  
{: .fs-6 .text-center .fw-700 .lh-default }

---

<div markdown="1" class="ghrepo-topdiv">

{: .ghrepo-callout }
Find this script at [this Github repo].


[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts

</div>


## Script Name:
{: .fs-5 .mb-4 }

F02_2_Get_FNmeZYYMM_Rcrd  
{: .lh-tight .mb-1 }

## Input:
{: .fs-4 .lh-default .mb-3 }

<!-- image here? -->

The output of `F01_FolderProcessing`. (See Preview Snippet 1 below.)  

NB: Our overall-process is *mostly* just nested functions. E.g. Like `OverallResult = Func3(Func2(Func1(Input)))`. However, F02_2_Get_FNmeZYYMM_Rcrd differs in that it re-uses `F01_FolderProcessing`'s output, (i.e. the same input as `F02_1_GetInitCsvTbls`'s used).


## Output:
{: .fs-4 .lh-default .mb-3 }

A `type record` value which appears like the following:  

<div markdown="1" class="scrolling-div-class">
![Output table](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/06-XChecked_Output-166w49h.jpg){: .img-noloadingppty width="166px" height="49px" style="aspect-ratio:166/49;" }
{: .my-1 }
</div>

In other words, a mapping of each statement's file-name to a 0.YYMM `type number` value.  
(NB: We can rely on the statement file-names being unique, because they're all from the same directory. Thus, they satisfy the `type record`'s 'unique field names' requirement.)  


Taking a macro perspective, we've seen that `F02_1_GetInitCsvTbls` added a from-0 index column to each statement's table. However, if we were to simply combine all the statements' tables, that index column would no longer serve its purpose as a unique identifier. (E.g. If our folder contains N files/statements, then we'd have N rows with `0` for their index column value.)  
*However,* we expect/require that the statements cover non-overlapping periods that are approximately 1 month long. Therefore, each statement should have a unique 0.YYMM value.[^yymm-val]  

[^yymm-val]: I.e. Where November 2025's "0.YYMM value" is `0.2511`.  
    (Also, admittedly, if our statements begin on the 15th of a month, and end on the 14th of the next month, then the assignment of a unique month to each statement will be much less intuitive.)

Therefore, if we add each file's 0.YYMM value to its index column value, then the decimal part will uniquely identify the statement, and the integer part will uniquely identify the statement's row. Thus, the index column would be a unique identifier even in the combined table. What a fortunate coincidence!  


## Observations:
{: .fs-5 }


###### The Output Hints At Where We're Going:
{: .fs-4 .pl-4 .lh-tight }

Taking an even more macro view, we know that `F02_1_GetInitCsvTbls`'s output has a `[Name]` column which contains each statement's file-name. Ergo, if we were to apply `Record.Field(F02_2_Rcrd, _)` to the `[Name]` column, then we would transform the column into 0.YYMM values which also unqiuely identify the statements/files.  

And, as above, this is desirable because the 0.YYMM values can be added to the index-column values. Further, they're also a more lightweight data type than the file-names.[^lightweight]  

[^lightweight]: If the file-names all happen to use few characters, then they could actually be more lightweight than the 0.YYMM values. However, this is unlikely.

Once such a `[0.YYMM]` column is constructed, then any neighbouring `[Name]` column would contain duplicate information. The efficient approach would be to remove the heavyweight `[Name]` column when the `[0.YYMM]` column is constructed. However, the file-name allows a debugger to quickly locate and inspect a source file. And so our scripts end up keeping the `[Name]` column around a little longer than is efficient.



###### Modular, User-Defined-Function-based Code:
{: .fs-4 .pl-4 .lh-tight }

This script heavily utilises user-defined functions (i.e. UDF's). Take for example, the script's first substantial transformation, the `table` assigned to `TblW_D8Pairs`.

`TblW_D8Pairs`'s expression uses our `CsvPeriod_ReaderFunc` UDF. So to see how `TblW_D8Pairs` is made, we go to `CsvPeriod_ReaderFunc`'s definition. But then `CsvPeriod_ReaderFunc` uses our `Get_D8_XChecked` UDF, and so now we've got to look into another definition!  
Such code can be a little frustrating, and if taken to an extreme, it would at least hurt readability. However, conventional wisdom is that functions that are smaller (and that have more specific purposes/tasks) make for more manageable, and generally better, code.  
This 'wisdom' is known as the 'Single Responsibility Principle.'

In other words, a most of the code is defining functions such as `CsvPeriod_ReaderFunc`. And code that 'actually does things,' (E.g. `X = Table.TransformColumns(T, {"C", CsvPeriod_ReaderFunc})`) is relatively rare, and uses few lines.


###### A UDF Is Used To Ship-Out A Substantial Portion of Code To Another Script:
{: .fs-4 .pl-4 .lh-tight }

See `F02_2Helper_ZYYMM_FromD8Pair`.  

The rationale for this is that lengthy scripts are less convenient to work with.


## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }

<div markdown="1" class="scrolling-div-class mt-4">
![Source Tbl](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/01-Source-F01sOutput-514w74h.jpg){: .img-lazy width="514px" height="74px" style="aspect-ratio:514/74;" }
{: .my-1 }
</div>

1. `fldrinfo_tbl`: This table is pretty familiar by now. It contains a pointer to each statement's file, and some other columns providing descriptions/metadata of the file.


<div markdown="1" class="scrolling-div-class mt-7">
![Content To Date-Pairs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/02-TblW_D8Pairs-359w224h.jpg){: .img-lazy width="359px" height="224px" style="aspect-ratio:359/224;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
2. `TblW_D8Pairs`: Now the `[Content]` column's `binary` values have transformed into 2-item `list`s which contain 2 `type date` values.  
   * Our TRR's contain metadata in their first several rows, before then presenting the main statement table/data. To obtain these values we've read in the TRR-file's values with alphanumeric addresses of E3 and F3. (And header-name cells E2 & F2 describe them as "From Date" and "To Date".)  
   * In our observation, these E3 & F3 cell-values are of a "YYYY-MM-DD HH:MM:SS" format. If we wished to rely on this, then we could extract characters 1-10 and use `Date.FromText` with a 2nd argument of `[Format = "yyyy-MM-dd]`.  
   * However, our script has opted to use a likely less-efficient approach, because we don't trust Zairwallex and want to be resilient to format changes. Essentially the approach used is `DateTime.FromText` with its default 'best effort' format recognition settings. However, the approach uses multiple `try`-statements and is a little more complicated than just `DateTime.FromText`.
   * In the end, we correctly read/interpret these datetime-string text values. However, even with our more robust approach, we aren't guaranteed correct-interpretation in the face of format changes. Ergo, it's prudent to vigilantly check for such changes over time.


<div markdown="1" class="scrolling-div-class mt-7">
![Csv Arg](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/02Arg-CsvArgs-415w85h.jpg){: .img-lazy width="415px" height="85px" style="aspect-ratio:415/85;" }
{: .my-1 }
</div>

* `CsvArgs`: As we can see here, this time, we have specified that there is *less* columns than the .csv file's metadata table actually contains. 
  Fortunately, `Csv.Document`'s documentation species that "if the number of columns is lower than the number found in the input, the additional columns will be ignored." Which, as implied, means that the line-break characters which separate the rows are also correctly parsed/identified.


<div markdown="1" class="scrolling-div-class mt-7">
![List To 0.YYMM](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/03-TblW_Z_YYMM_s-352w78h.jpg){: .img-lazy width="352px" height="78px" style="aspect-ratio:352/78;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
3. `TblW_Z_YYMM_s`: The `[Content]` column's `list` values have now transformed to `type number` 0.YYMM values. This is achieved using a function defined by another script. However, the process used can be descrived as follows:  
   * If the From-Date and To-Date have the same day value, and the To-Date is in the month after the From-Date, then we simply take YY and MM from the From-Date.  
   * Otherwise, we get the number of days between the From-Date and To-Date, add half that number of days to the From-Date (let's call this date 'Mid-Date'), and then take take YY and MM from the Mid-Date.  
     And of course, once the YY & MM values are obtained, simple arithmetic gets us a 0.YYMM value.


<div markdown="1" class="scrolling-div-class mt-7">
![FNme 0.YYMM Record](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/04-FName_ZYYMM_Rcrd-165w51h.jpg){: .img-lazy width="165px" height="51px" style="aspect-ratio:165/51;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
4. `FName_ZYYMM_Rcrd`: `Record.FromTable` is used to transform the previous table into a `type record` value.  

<div markdown="1" class="scrolling-div-class mt-7">
![FNme 0.YYMM Record](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/05-All_YYMMs_Different-251w61h.jpg){: .img-lazy width="251px" height="61px" style="aspect-ratio:251/61;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
5. `All_YYMMs_Different`: Step 4's record is in the format that we desire for this script/function's output. However, it also puts us in a position to perform a data quality check. And so we make this script's output dependent on that check.  
   Specifically, the `[Content]` column (i.e. `list` value) from step 3's table contains all of the statements' 0.YYMM values.  
   We won't rely on `F01_FolderProcessing` (i.e. its use of `Folder.Contents`) reading in the statement files in chronological order (which probably relies on the file-names' alphabetical order coinciding with their report-period chronological order). Simply because we're not sufficiently confident that this will always be the case.  
   However, we certainly don't want report periods duplicated (e.g. because the TRR file-names were manually renamed, and July 2025's file was mistakenly renamed to "TRR-06-2025.csv"). Therefore, we conduct a data quality check that the 0.YYMM values are unique. This is easily achieved using the `List.IsDistinct` function.  
   If this check is not satisfied, then it could be due to duplicate reports, but it could also be other issues. For example, our code may be interpreting the datetime strings according to an inappropriate format (thus our 0.YYMM values are derived from incorrect dates). Or, perhaps we're correctly reading in dates, but there's an issue with our process for getting the 0.YYMM values from them.


<div markdown="1" class="scrolling-div-class mt-7">
![FNme 0.YYMM Record](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F02_2/06-XChecked_Output-166w49h.jpg){: .img-lazy width="166px" height="49px" style="aspect-ratio:166/49;" }
{: .my-1 }
</div>

{: style="counter-reset:none"}
6. `XChecked_Output`: Although not apparent from the above image, because the above variable / check-result is `true`, our function's output is that of step 4's.  
   If the check-result was `false`, then an error would be raised, which would terminate our process, but point us towards the issue encountered.  
   This is appropriate, because if we were to ignore the issue discovered, our results would surely be based on incorrect data. Of course, such output/results would likely be nonsensical, and in any case, should not be used.

---

