---
layout: default
title: F01 - Directory Path To Files-Info Table 
parent: Scripts
nav_order: 301
---

# Directory Path To Files-Info Table  
{: .fs-6 .text-center .fw-700 .lh-default }

---

<div markdown="1" >

{: .ghrepo-callout }
Find this script at [this Github repo].

[this Github repo]: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/tree/main/BankDataPt1-Scripts 

</div>
<!-- {: .ghrepo-callout }
	Find this script at [this Github repo].{: .fs-5 .pl-5 } -->
<!-- <blockquote markdown="1" >
	<p markdown="1" class="ghrepo-callout fs-5 pl-5">Find this script at [this Github repo].</p>
</blockquote> -->

## Script Name:
{: .fs-4 .lh-default .mb-4 }

F01_FolderProcessing
{: .lh-tight .mb-1 }

(*F*01 because the script/query gets a functions.)
{: .fs-3 .lh-tight .mt-2 .pl-4 }

## Input:
{: .fs-4 .lh-default .mb-3 }

A simple directory-path `type text` value.  

In our example it is: `"C:\Sample_TRRs"`
{: .mb-1 }

NB: In PQFLang, enclosing characters in " or ' denotes a `type text` value. 
{: .fs-3 .lh-tight .mt-1 .pl-4 }

## Output: 
{: .fs-4 .lh-default .mb-3 }

<!-- Can get below link via: https://github.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/blob/main/docs/assets/images/F01/07_Output_Tbl-520w77h.jpg?raw-true i.e. the ?raw=true url query parameter-->

A table with rows like the following:
{: .mb-1 }

<div markdown="1" class="scrolling-div-class">
![Output table](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/07_Output_Tbl-520w77h.jpg){: .img-noloadingppty width="520px" height="77px" style="aspect-ratio:520/77;" }
{: .my-1 }
</div>

However, this small table does not reflect the valuable tasks that this script performs.
{: .mt-1 }

These include: 
* Reviewing the directory's files, and removing any irrelevant files (e.g. any .pdf or .docx files); and
* Efficiently determining whether a TRR-file is an old-style (x28-columns) or new-style (x29-columns) TRR statement. 
  * ('Efficient,' because rather than scanning through a TRR's entire file, we only read in a precisely specified cell-location within the file.)


## Observations: 
{: .fs-5 .lh-default }

1. As below, this script mostly transforms a table with many columns, only to remove most of them as one of the last steps. This is less efficient than removing those columns ASAP. However, this inefficiency is trumped by the debugging value of being able to easily preview them.[^preview]

[^preview]: Thus the images in the below Preview Snippets section.

{: style="counter-reset:none" }
2. Similarly, the script could have immediately produced boolean values when the `[HasX29Cols]` column was created. Instead, an extract of the header-name of each file's 28th column is initially displayed. That way, a debugger can scan through the preview, and can easily detect unexpected behaviour, according to whether any of the initial `[HasX29Cols]` columns are text other than "Bank" or "Name".

3. The `try` statement is used so that our error-checking is intuitively displayed in a `record` format. This is demonstrated by the 6th image.


## Preview Snippets:
{: .fs-5 .lh-default .mb-4 }

<div markdown="1" class="scrolling-div-class mt-6">
![Folder Info](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/01-FolderInfo-1318w109h.jpg){: .img-lazy width=1318 height=109 style="aspect-ratio:1318/109;" }
{: .my-1 }
</div>

{: .my-1 }
1. `FolderInfo`: PQFLang's `Folder.Contents` function gets a table of information about the files in the folder. Usefully, The table's rows include:
   * the file-name (inclusive of file extension); 
   * the file's extension (inclusive of the "." prefix); 
   * the file's content as a `type binary` value; and 
   * a `record` containing much more information about the file.
{: .mb-1 }

<div markdown="1" class="scrolling-div-class mt-6">
![Remove Hidden Files](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/02-RemoveHiddenFileRows-1316w75h.jpg){: .img-lazy width=1316 height=75 style="aspect-ratio:1316/75;" }
{: .my-1 }
</div>

{: style="counter-reset:none" }
2. `RemoveHiddenFileRows`: Removing hidden files requires transforming the previous `[Attributes]` column from a `record` to its `type logical` (i.e. Boolean) "Hidden" field.
   Because we're confident that the "Hidden" field will only take values of `true` and `false`, we use the `Table.RemoveMatchingRows` function instead of the `Table.SelectRows` function.  
   `Table.RemoveMatchingRows` appears to be analogous to the `List.RemoveMatchingItems` function. Unlike `Table.SelectRows`, we're able to specify (via the 3rd argument) that row removal/selection depends *only* on the `[Hidden]` column, and that it depends on equality testing it.[^equal-test] Therefore, under-the-hood, implemented in lower-level languages, this function presumably utilises more assumptions, and thereby uses more specialised and efficient code.  
   For example, we can see that `Table.SelectRows` uses an iterator that yields all of the table's row (i.e. in `record` form), which is then passed to the function that we provide as `Table.SelectRows`'s 2nd argument. In contrast, `Table.RemoveMatchingRows` apparently uses a more lightweight iterator that only contains the `[Hidden]` field for each row/iteration.  
   Similarly, `Table.SelectRows` depends on the 2nd-argument UDF that we pass in to it, and it's defined using high-level PQFLang. In contrast, `Table.RemoveMatchingRows` is really provided with a constant value rather. Presumably, its lower-level implementation is only capable of performing an equality test, and that enables performance benefits. 

[^equal-test]: I.e. In this case, a `= true` test/comparison being applied to the `[Hidden]` column's values. Intuitive this is one of the most computationally cheap operations possible.  
    NB: The `Table.RemoveMatchingRows`'s 2nd argument must be a list of records, and thus in the form of `{[field1 = val1, field2 = val2, ...], ...}`. I.e. `Table.RemoveMatchingRows` Can't use inequality or greater/lesser tests (e.g. `{[f1 <> val1, f2 < v2]}` is invalid).

<div markdown="1" class="scrolling-div-class mt-6">
![Prep For HasX29Cols](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/03-AddPrep4Future_HasX29Cols-1477w112h.jpg){: .img-lazy width=1477 height=112 style="aspect-ratio:1477/112;" }
{: .my-1 }
</div>

{:style="counter-reset:none"}
3. `AddPrep4Future_HasX29Cols_Col`: As observed above, we conspicuously 'stop short,' when it would be easy to immediately create the `[HasX29Cols]` column in its ultimate `type logical` form. Thus, debuggability is improved by the ability to preview the relevant header-name values.














{: style="counter-reset:none"}
2. `RemoveHiddenFileRows`: Removing hidden files requires transforming the previous `[Attributes]` column from a `record` to its `type logical` (i.e. Boolean) "Hidden" field.
   Because we're confident that the "Hidden" field will only take values of `true` and `false`, we use the `Table.RemoveMatchingRows` function instead of the `Table.SelectRows` function.  
   `Table.RemoveMatchingRows` appears to be analogous to the `List.RemoveMatchingItems` function. Unlike `Table.SelectRows`, we're able to specify (via the 3rd argument) that row removal/selection depends *only* on the `[Hidden]` column, and that it depends on equality testing it.[^equal-test] Therefore, under-the-hood, implemented in lower-level languages, this function presumably utilises more assumptions, and thereby uses more specialised and efficient code.  
   For example, we can see that `Table.SelectRows` uses an iterator that yields all of the table's row (i.e. in `record` form), which is then passed to the function that we provide as `Table.SelectRows`'s 2nd argument. In contrast, `Table.RemoveMatchingRows` apparently uses a more lightweight iterator that only contains the `[Hidden]` field for each row/iteration.  
   Similarly, `Table.SelectRows` depends on the 2nd-argument UDF that we pass in to it, and it's defined using high-level PQFLang. In contrast, `Table.RemoveMatchingRows` is really provided with a constant value rather. Presumably, its lower-level implementation is only capable of performing an equality test, and that enables performance benefits. 

[^equal-test]: I.e. In this case, a `= true` test/comparison being applied to the `[Hidden]` column's values. Intuitive this is one of the most computationally cheap operations possible.  
    NB: The `Table.RemoveMatchingRows`'s 2nd argument must be a list of records, and thus in the form of `{[field1 = val1, field2 = val2, ...], ...}`. I.e. `Table.RemoveMatchingRows` Can't use inequality or greater/lesser tests (e.g. `{[f1 <> val1, f2 < v2]}` is invalid).




<div markdown="1" class="scrolling-div-class">
![Remove Hidden Files](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/02-RemoveHiddenFileRows-1316w75h.jpg){: .img-lazy width=1316 height=75 style="aspect-ratio:1316/75;" }
</div>

2. Removing hidden file rows requires transforming the previous `[Attributes]` column from a `record` to its `type logical` (i.e. boolean) "Hidden" field.
	Also, because we're confident that the "Hidden" field will only take values of `true` and `false`, we use the `Table.RemoveMatchingRows` function instead of the `Table.SelectRows` function.  
	`Table.RemoveMatchingRows` appears to be analogous to the `List.RemoveMatchingItems` function. Unlike `Table.SelectRows`, we're able to use the 3rd argument to specify that row removal/selection depends *only* on the `[Hidden]` column, and that it depends on equality testing it[^equal-test]. Therefore, under the hood, implemented in lower-level languages, this function may rely on more assumptions and thereby use more specialised and efficient code.
	For example, we can see that `Table.SelectRows` uses an iterator that yields all of the table's rows (i.e. in `record` form) and then applies the function we pass in as the 2nd argument to each iteration. In contrast, `Table.RemoveMatchingRows` apparently uses a more lightweight iterator that only contains the `[Hidden]` field for each row/iteration.  
	Similarly, `Table.SelectRows` depends on the UDF we pass in as the 2nd argument and is defined using the high-level PQFLang. In contrast, `Table.RemoveMatchingRows` is really provided with a value rather than a function, ergo, it apparently implements the iterative remove/select computation using lower-level (and thus more performant) code.
[^equal-test]: I.e. In this case, a `= true` test/comparison being applied to the `[Hidden]` column's values. Notably, this is a relatively simple operation. Whereas, e.g. `(x * 1.27)^0.5 < 3.14` is a more complex and computationally expensive operation.

<div markdown="1" class="scrolling-div-class">
![Prep For HasX29Cols](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/03-AddPrep4Future_HasX29Cols-1477w112h.jpg){: .img-lazy width=1477 height=112 style="aspect-ratio:1477/112;" }
</div>

3. As observed above, we conspicuously 'stop short,' when it would be easy to immediately create the `[HasX29Cols]` column in its ultimate `type logical` form. Thus, debuggability is improved by the ability to preview the relevant header-name values.


<div markdown="1" class="scrolling-div-class">
![Add HasX29Cols](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/04-Add_HasX29Cols-1481w113h.jpg){: .img-lazy width=1481 height=113 style="aspect-ratio:1481/113;" }
</div>

4. A simple transform to get the `[HasX29Cols]` column in `type logical` form.


<div markdown="1" class="scrolling-div-class">
![Remove Irrelevs](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/05-RemoveIrrelevs-517w73h.jpg){: .img-lazy width=517 height=73 style="aspect-ratio:517/73;" }
</div>

5. Removing columns that don't impact our ultimate bank-statements table/data. (Although, as discussed, may be useful clues to a debugger.)


<div markdown="1" class="scrolling-div-class">
![Error Check](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/06-HasX29_ErrorCheck-178w86h.jpg){: .img-lazy width=178 height=86 style="aspect-ratio:178/86;" }
</div>

6. We can rely on the `try` statement returning a record with a "HasError" field, and if there is no error, then also a "Value" field. The `record` may be an unnecessarily large and detailed data structure for this error-checking task. However, it promotes readable and intuitive code.
	* Even though PQFLang doesn't provide the typical 'for-loop' etc. control flow mechanisms that most programming languages do, we can still add break-conditions to iterative calculations. Here, this is achieved by using `Table.FirstValue`.


<div markdown="1" class="scrolling-div-class">
![Output](https://raw.githubusercontent.com/pburke-hub/BankDataPrjct-Pt1-TRRsToTables/main/docs/assets/images/F01/07_Output_Tbl-520w77h.jpg){: .img-lazy width=520 height=77 style="aspect-ratio:520/77;" }
</div>

7. Finally, because our example data does not raise an error, we output the same data as in step 5.
