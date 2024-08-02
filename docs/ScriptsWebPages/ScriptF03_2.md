---
layout: default
title: F03_2 - Select Columns, Add [UID], [CsvOrderIdx]
parent: Scripts
nav_order: 305
---


# Select Columns, Add [UID], [CsvOrderIdx]
{: .fs-6 .text-center .fw-700 .lh-default }

The code used here is very simple ...  
However, it is the first time we handle precision issues of `type number` (via `NumberRound`)

---

<div markdown="1" class="ghrepo-topdiv">

{: .ghrepo-callout }
Find this script at [this Github repo].


[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts

</div>


## Script Name:
{: .fs-4 .lh-default .mb-4 }

F03_2_RemovRedundCols_Add_UID_CsvOrderIdx_Cols  


## Input:
{: .fs-4 .lh-default .mb-3 }

<!-- image here? -->

The output of `F03_2_RemovRedundCols_Add_UID_CsvOrderIdx_Cols`.


## Output:
{: .fs-4 .lh-default .mb-3 }

The same table, except: we've removed some irrelevant columns; and added two new columns, `[UID]`, and `[CsvOrderIdx]`.  

* `[UID]` is each file's index integer plus the file's 0.YYMM. As foreshadowed in earlier scripts' webpages.  

* `[CsvOrderIdx]` is a column of integers, starting from 0. Just like the index columns we generated at the individual-file level, but now for the combined table.  
  * If we're ever concerned that our combined-table has lost its original row-order, then instead of needing to sort by x2 columns,[^x2-cols] we can just sort by `[CsvOrderIdx]`.  
  * Also, as long as any rows aren't removed and row-order is preserved, then `[CsvOrderIdx]` gives us a row's location / index-value.

[^x2-cols]: I.e. Sorting by `[Z_YYMM]` first, and then by `[UID]`.

## Observations:
{: .fs-5 .lh-default }

This script is straightforward in terms complexity of operations and PQDFLang used.

However, it is the first time that the scripts perform arithmetic operations on non-integer (a.k.a. floating point) numbers.

A nice characteristic of integers is that, given a data-type constraint (e.g. 64-bit values), there's a set amount of values that can be represented.

For example, in SQL Server (i.e. using T-SQL) the 8-bit integer data-type is constrained to numbers in {0, 1, 2, ..., 255}. While the 16-bit integer data-type is constrained to numbers in {-32,768, -32,767, ..., 32,767}.[^int_data_types]  

[^int_data_types]: See https://learn.microsoft.com/en-us/sql/t-sql/data-types/int-bigint-smallint-and-tinyint-transact-sql?view=sql-server-ver16 Also, NB: unsurprisingly, the 8-bit type can only represent 2^8 different values, and the 16-bit type can only represent 2^16 different values. 

However, we're dealing with `type number`, and it's not as nice. Unlike integer data types, it's able to represent floating point numbers. However, as foreshadowed, if a data-type represents floating-point values, then 'something's gotta give' - i.e. there has to be some approximating done somewhere.  

For example, even within small ranges (e.g. between 0.1 to 0.2) there's an infinity of floating point numbers. And yet, the `type number` data-type uses a finite number of bits.  
Ergo, even with a floating point data-type that uses 128-bit values, it'd be able to represent 3.4 \* 10^38 different values. And yet, unlike integer data types, it'd still be impossible to concisely describe the data-type's range as e.g. 'covering all numbers between 0.1 to 0.2.'  
Clearly there will be plenty of values that the `type number` is unable to represent. 

The `type number` is similar to a bog-standard 64-bit floating-point data-type. So, provided the total number of digits used is less than 15, then it usually provides a good approximation of any given value. I.e. It's able to represent a lot of different values.

Given that we're using such a heavyweight (64-bit) data-type, you might expect that e.g. as long as you're dealing with integers (or as long as our numbers are <100,000, and only ever use 2 decicmal places) then your arithmetic addition/subtraction operations will return perfectly correct results. After all, the `type number` is actually able to represent all numbers between {0.01, 0.02, ..., 99,999.99}.  

You'd be wrong!  

Sometimes, even these unsuspicious expressions (e.g. `1.01 + 2`) will return a value that's ever-so-slightly off (e.g. `3.0099999999999998`). And this will be so, even though the data-type is capable of representing `3.01`-exact.[^arith-error]

[^arith-error]: This is a phenomenon common to many programming languages. Microsoft could change what PQFLang's `+` operator does, to something that's less performant, but doesn't ever return such errors. Presumably, because only we know how many decimal points we want, it's left up to the user to be aware of the issue and to round results.

In summary, despite how impressive our computers/programming-languages are, they can be surprisingly unimpressive at floating point arithmetic.  

Such inaccuracies are unacceptable for our case. We want to be able to split our our table into different groups of columns, (although both having `[UID]`) and then later be able to join the groups/tables, by matching the rows with *equal* `[UID]` values. However, if only x1 of the tables' `[UID]` values has had arithmetic operations on it, then those slight differences would ruin our join.

Fortunately, we can simply use `Number.Round` on our arithmetic expressions, and (given our UID values have no more than 4 decimal/left-side digits) we'll ensure that we get perfectly correct results.

Rest TO DO

## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }

<div markdown="1" class="scrolling-div-class mt-4">
![Folder Info](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_2/01-RemoveSrcID_Status-LISTOFCOLS-173w461h.jpg){: .img-lazy width=173 height=61 style="aspect-ratio:173/461;" }
{: .my-1 }
</div>

{: .my-1 }
1. `RemoveSrcID_Status`: A simple `Table.RemoveColumns`-call to remove the `[Source Id]` and `[Status]` columns. 


<div markdown="1" class="scrolling-div-class mt-7">
![Remove Hidden Files](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_2/02-Uniq_Trnsn_IDs-CouldReUseOldTho-384w138h.jpg){: .img-lazy width=384 height=138 style="aspect-ratio:384/138;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 1"}
2. `Uniq_Trnsn_IDs`: The `[Transaction Id]` column is a typical GUID.[^guid] So in substance it's a 32-character string whose characters are either within 0-9 or a-f. However, the 32-characters are separated by hyphens into a 8-4-4-4-12 grouping, so ultimately 36 characters are used.  
   (Such a 32 character string (again) has 3.4 \* 10^38 different values. And so even if the GUID's are generated randomly, the chances of generating duplicate GUID's are virtually none.)[^collisn]
   And again, as typical, Zairwallex uses these as a unique identifier for each transaction.[^z-uid] And presumably, if there was a duplicate GUID among Bikeworks' transactions, then Zairwallex's systems would automatically identify it and rectify it.  
   Ergo, if we have duplicate `[Transaction Id]` values, then it's almost certainly because our statements double-cover some overlapping time/date period.  
   As such, this `Uniq_Trnsn_IDs` variable uses `List.IsDistinct` to check same.  
   Using simple if-then logic, the next (not-sippet'ed) `XChecked_Tbl` raises an error if we have duplicate `[Transaction Id]` values, and otherwise the script continues.

[^guid]: I.e. Globally Unique Identifier. A.k.a. Universally Unique Identifier (UUID). See https://en.wikipedia.org/wiki/Universally_unique_identifier for more.

[^collisn]: For example, to get a 50% chance of a duplicate, one needs to generate 2.7 \* 10^18 GUID's. Which could be done by generating 1 billion GUID's per second for approx. 86 years See https://en.wikipedia.org/wiki/Universally_unique_identifier#Collisions.

[^z-uid]: In fact, even to distinguish between the record of when the transaction was pending vs. the record of when it was settled.


<div markdown="1" class="scrolling-div-class mt-7">
![Prep For HasX29Cols](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_2/03-Add_UID_Col-461w250h.jpg){: .img-lazy width=461 height=250 style="aspect-ratio:461/250;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 2"}
3. `Add_UID_Col`: Often the scripts have used extra lines in order to avoid `Table.AddColumn`. In this case, we need to make reference to both `[IdxByMth]` and `[Z_YYMM]` for each row. Ergo, we bite the bullet and use `Table.AddColumn`.  
   A multi-line `let`-statement is used for this `Add_UID_Col` variable. However, `Add_UID`'s `columnGenerator`-function could easily be enclosed by `Number.Round`, so that a single `Table.AddColumn` call is used.  
   The main advantage of our code is that it's more readable (albeit taking more lines). Another potential advantage is that if we fear that `Table.AddColumn` might be relatively inefficient, we've minimised the amount of work it does.


<div markdown="1" class="scrolling-div-class mt-7">
![Remove Hidden Files](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F03_2/04_AddCsvOrderIdx-299w251h.jpg){: .img-lazy width=299 height=251 style="aspect-ratio:299/251;" }
{: .my-1 }
</div>

{:style="counter-reset:step-counter 3"}
4. `AddCsvOrderIdx`: This is a simple use of `Table.AddIndexColumn(SomeTable, "IndexColName", 0, 1, type number)`.  
   - However, the final 3 arguments are unnecessary because they're the same value as their default value. They're included to be explicit, and thus improve readability.

---


