---
layout: default
title: F03_3 - Typecast Columns, Clean Text, Get [Date]
parent: Scripts
nav_order: 306
---

## F03_3 - Typecast Columns, Clean Text, Get \[Date\]  
{: .fs-6 .text-center .fw-700 .lh-default }

Just adding some text here to make an alteration and trigger a re-depolyment of the github pages website.

---

<div markdown="1" class="ghrepo-topdiv">

{: .ghrepo-callout }
Find this script at [this Github repo].


[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts

</div>


## Script Name:
{: .fs-4 .lh-default .mb-4 }
F03_3_TypCast_Cln_AddD8Col  


## Input:
{: .fs-4 .lh-default .mb-3 }

<!-- image here? -->

The output/table from `F03_2_RemovRedundCols_Add_UID_CsvOrderIdx_Cols`. Which is a table with lots of columns, including the new columns of: `[UID]` (of x.YYMM-style decimals); and `[CsvOrderIdx]` (a from-0 sequence of integers) .


## Output:
{: .fs-4 .lh-default .mb-3 }

The same table, except for the following changes:  
* "Number columns" (e.g. `[Exchange Rate]`, `[Settlement Amount]`, etc.) have had their column (and values) converted from `type text` to `type number`.  

* "Date columns" (i.e. `[Settled At]`, `[Created At]`) have been replaced by a single column called `[Date]`, which is of `type date`.  

* The remaining columns are still of `type text`, but have been cleaned of leading/trailing spaces, and have had 'non-printable' characters (e.g. new-line, tab, etc.) removed.  


## Observations:
{: .fs-5 .lh-default }

This script is straightforward. 

One perhaps-unusual function used is `Text.Clean`. It deletes what are known 'control characters' from anywhere they occur in our text values. (Control characters include formatting characters such as the tab and new-line characters. See https://en.wikipedia.org/wiki/Control_character for 'control characters' definition.)

If `Text.Clean` changes our data at all, it's probably because it removes a new-line or tab character. This may cause two words to be joined together. That isn't ideal, but it probably isn't too hard to discern a typo of two words that are joined.  
As reward, our text values will be more concise, and easier for our accountants to read. 


## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }


<div markdown="1" class="scrolling-div-class">
![To Dates](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_3/01-D8_TypCastd_Tbl-586w127h.jpg){: .img-lazy width="586px" height="127px" style="aspect-ratio:586/127;" }
</div>


1. `D8_TypCastd_Tbl`: The script hard-codes in `{"Created At", "Settled At"}` to identify which of the table's columns should be converted from `type text` to `type date`. It then uses `DateTime.FromText(_)` to get a `type datetime` value, using a "best efforts" algorithm to recognise the datetime's format. 
   (We expect, the format to be "yyyy-MM-dd HH:mm:ss", and could specify this. However, if we do so and the TRR format changes, then the `DateTime.FromText(_, "yyyy-MM-dd HH:mm:ss")` will error without trying its "best efforts" algorithm as a catch-all.)



   Finally, `DateTime.Date` is used to convert from `type datetime` to `type date`.  

   As mentioned, neither of these columns will survive in the final output. However, they are the basis of the new/to-be-added `[Date]` column.  

<!-- TODO = check that "yyyy-MM-dd HH:mm:ss" used x2-times above is correctly used. 
Yes it is. See Eg3 of https://learn.microsoft.com/en-us/powerquery-m/datetime-fromtext OR See https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings -->


<div markdown="1" class="scrolling-div-class">
![Typed Cols](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_3/02_TypdTbl-Extract-1033w145h.jpg){: .img-lazy width="1033px" height="145px" style="aspect-ratio:1033/145;" }
</div>


{:style="counter-reset:step-counter 1"}
2. `TypdTbl`: This preview image shows an extract of some of the columns that are typecasted from `type text` to `type number`.  
   Like the columns typecasted into dates, the columns to be typecasted are hard-coded in.
   <br>
   `Number.FromText` is used, instead of `Number.From`, because it's more specific, and presumably uses lower-level / under-the-hood code that's more efficient/optimised for this task.


<div markdown="1" class="scrolling-div-class">
![Source Tbl](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_3/03_TblOfClnTxt-439w106h.jpg){: .img-lazy width="439px" height="106px" style="aspect-ratio:439/106;" }
</div>



{:style="counter-reset:step-counter 2"}
3. `TblOfClnTxt`: This preview image shows some of the leftmost text columns after `Text.Clean(Text.Trim(_))` has been applied to them.  
   Re `Text.Trim` for our purposes leading or trailing space characters are unlikely to do us harm. However, they do make our data slightly larger for no anticipated benefit. Further, they may cause our values to be mis-interpreted (e.g. I may interpret the `[Type]` to contain the value "Card", but then when I try filter for that value, I'm frustrated to then discover that sometimes the value is "Card" and other times it's "Card ").






<div markdown="1" class="scrolling-div-class">
![Source Tbl](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_3/04-Add_D8_Col-425w145h.jpg){: .img-lazy width="425px" height="145px" style="aspect-ratio:425/145;" }
</div>


{:style="counter-reset:step-counter 3"}
4. `Add_D8_Col`: This preview image shows the `[Date]` column.  
   If `[Settled At]` always had a non-null `type date` value, then we would use it. However, `[Settled At]` is null/empty for many types of transactions. In those cases, our `[Date]` column resorts to using `[Created At]`'s value.  
   `Table.CombineColumns` is used here, and it's a good tool for the job. In a single function-call, it ex-ante informs the low-level code to only focus on the `[Created At]` & `[Created At]` columns (in contrast to e.g. `Table.AddColumn`). And further, it informs that both of those columns should be dropped, in favour of the new `[Date]` column that will be created.


---

