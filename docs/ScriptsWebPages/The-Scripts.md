---
layout: default
title: The Scripts
has_children: true
nav_order: 300
---

<!-- For now, let's have this as a parent page. However, ultimately, let's have it as something which has the ToC and highlights the order of and relations of the scripts (E.g. how `Tbl_AddLstCol` is a genuine helper-func.) -->

# The Scripts
{: .fs-6 .text-center .fw-700 .lh-default }

## General Description Of The Scripts:
{: .fs-5 .lh-default }

PQFLang is a functional language. So unsurprisingly, these scripts give us functions on functions on functions.

Most of the scripts create a single function. Specifically, a function that applies a sequence of in-built PQFLang transformation-functions. One of the scripts even creates a function which specifies for our first script's function to be used, then our second script's function to be used on its output, and so on.

An alternative design would be to use a single script. With that script still creating a single function, and specifying for the same sequence of transformations.  
However, for many intuitive reasons, it's more convenient to have our code organised into separate, small scripts.[^script-size] 

[^script-size]: Personally, with PQFLang, I find approximately 100-lines, including thorough commenting and blank-lines/whitespace, to be my sweet spot.

Perhaps surprisingly, although our design has that extra, unnecessary orchestrating script/function, in PQFLang, it unlikely comes at much of a cost.[^perf-detail]

[^perf-detail]: If the same design were used in other, especially lower-level, languages, it indeed would cause the 1st function's output to be held in RAM, while the 2nd function's output also occupies memory, and so on. However, PQFLang, especially being a functional language, and one which often uses lazy evaluation, avoids such an inefficient outcome.

## x3 Quick Disclaimers:
{: .fs-4 .lh-default }

The scripts usually include some code like:
```
Source = Init_Val,
Tformd_Val = Source + 1,
Result = Tformd_Val,
```
{: .lh-tight }

Clearly the `Result`-line is unnecessary. However, as it turns out, if we wish to cut and paste various parts of scripts into a Frankenstein script, (e.g. for debugging) then this is a convenient form. It also keeps the scripts in a form which Excel/Power BI will preview each step of the script.[^previews]

[^previews]: The 'Power Query Editor,' as accesed via Excel/Power BI, will preview the values of each step/variable of a script, only if the script's final line is also the output of the script.
    Testing whether x4 spaces will provide a multi-line footnote.

Yes, the extra lines may look weird. However, these lines are usually at the top or bottom of the scripts. So it's easy to exclude them when copying and pasting a script's content into Excel/Power BI.

Secondly, when entering a script into Excel/Power BI, it's best to configure it to *not* load into the spreadsheet/data model.[^not-load] Both Excel and Power BI come with more overhead than we'd like, and writing unnecessary data only exacerbates the overhead.

[^not-load]: When using Excel, this is achieved by opting for 'Create Connection Only,' and by not loading the query/script to any spreadsheet location.

Third, if using VS Code with a script, it will alert to errors within it. So similar to the unnecessary `Result` variable, if a script references a user-defined *global* variable,[^glob-var] then VS Code will consider that an erroneous reference to an undefined variable. To prevent this, often the top of a script will include a line like: `External_Script_s_Output = "",`. Thus, VS Code considers the variable to be defined, even though such lines are never going to be added into our Excel/Power BI solution.

[^glob-var]: By "user-defined global variable," really meaning a variable that's created by a different script. Thus, it will be available within our ultimate Excel/Power BI environment. However, within the single script, it's not defined.

Again, since these hacky workaround are conspicuously located at the top of a script, they're easy to exclude.

An example of this is what I've called helper-function scripts. I've made these scripts where the code of an intuitively distinct task is too long. To get the task's code into scripts of a more manageable length, part of the code is cut out of the long script and pasted into the helper-function script. And in place of the code that was cut out, is a single call of the helper-function.


## How To Use The Scripts:
{: .fs-5 .lh-default }

We need to *manually* copy and paste them into Excel/Power BI. Urghh!
{: .lh-tight }

### What We Can't Use The Scripts To Do:
{: .fs-4 style="padding-left:1.2em;" .lh-default }

For many languages, the instructions for executing a script can be as simple as:
{: .lh-tight }
* Save the script to "C\"; 
* Open a command line interface (in Windows, e.g. 'Command Prompt' or 'Powershell'); 
* Type "python C:\my_script.py" and then Enter.
{: .lh-tight }

Specifically, the language (e.g. Python above) has an interpreter which is able to execute script files.

PQFLang isn't offered as a language that comes with an interpreter. So, in the absence of an interpreter, we need something else to execute our code.  
As mentioned, Excel and Power BI can be used to execute PQFLang. (In addition, apps such as Visual Studio and SQL Server Management Studio can also use PQFLang.\)^[smss]

[^smss]: Although, an instance of SQL Server Analysis Services needs to be available, in addition to having the VS/SMSS app installed. And even then, to view or archive the output, another app like Excel or Power BI would still be needed.

The upshot is: Unfortunately, there isn't a convenient way to execute PQFLang scripts.

So we're deprived of the conveniences of scripts, such as:
{: .lh-tight }
* any text editor can author them 
  * (e.g. nice lightweight apps);
* multiple solutions that perform an identical task, can refer to the one script file for that task
  * As such, if that task's code needs to be updated, only one update is required. In constrast to altering a different file for each solution; and 
* When it's easy to execute a language's scripts via an Operating-System-interfacing CLI, then often it's easy to schedule such script to run periodically.
{: .lh-tight }

Microsoft's VS Code is a convenient text editor for authoring PQFLang code. However, the scripts we author can't be called/referred-to by Excel/Power BI.  
Instead, we need to copy and paste our script's content into Excel/Power BI.[^scripts-defn]

[^scripts-defn]: (In fact, although the PQFLang text files are referred to as scripts. They don't offer the same conveniences described above, so arguably they're not scripts.)

A final, conspicuous deficit of PQFLang is its inability to serialise. Most languages have an ability to create and write data to files. In PQFLang, such a feature *could* be available through a function like `Text.Write("This is line 1.", "C:\file.txt")`. However, such a function doesn't exist. 

Instead, we are forced to use 'load' the results of a PQFLang script in Excel/Power BI (which will result in the data being written somewhere in the .xlsx/.pbix file). And from there, we can copy the data into our desired file format.[^file-frmt]

[^file-frmt]: Although, quite likely requiring some minor transformations to the pasted-out Excel/Power BI data, before it's in the form that we desire for writing to the different type of file.

### Entering The Scripts Into The Power Query Editor:
{: .fs-4 style="padding-left:1.2em;" .lh-default }

Both of Excel and Power BI accept PQFLang code through a GUI called the Power Query Editor. Within that GUI, we create 'Queries', and we can view and edit a Query's PQFLang code using the GUI's Advanced Editor.

Some unusual aspects of PQFLang and the Power Query Editor are:
{: .lh-tight }
* PQFLang variables are immutable. 
  * I.e. Once a value is assigned to a variable, we can't subsequently assign a different value to it.
* Queries/scripts must produce a single value/object.
* A Query/script may depend on other queries, because the other Queries' names are available as if they are local variables (and obviously correspond to that query's output).
{: .lh-tight }

As mentioned above, your computer and your patience will thank you if none* of your Queries use the default property/configuration of loading to the spreadsheet/data model.  
\*I.e. Configure a Query to load, *only* if its output is the data that you wish to serialise.


### Giving PQFLang A Fair Hearing:
{: .fs-4 style="padding-left:1.2em;" .lh-default }

Above noted many downsides of using PQFLang. However, the following provides a more balanced impression. For example, based solely on the above, perhaps PQFLang ought not to exist at all and should never be used. Which seems unlikely.

One point in defence is that, while our hypothetical case requires pasting-in our code, that isn't always the case for PQFLang. PQFLang scripts can be used create a Power Query Connector .mez file. Then, by *mere reference*  to that file, Excel/Power BI gets the desired end-data in accordance with our PQFLang code.


<!-- V = seems long. And def's a candidate for collapsible section! -->
##### Compatability & Performance:
{: .fs-4 style="padding-left:2em;" .lh-default }

PQFLang has in-built connectors that enable it to get data from a wide variety of [data sources](https://learn.microsoft.com/en-us/power-query/connectors/). Extracting data from disparate sources into a single environment can be a challenge. When such a challenge is faced, then PQFLang becomes convenient.

For example, one of Power BI's purposes is visualise data *despite* the data coming from a disparate range of underlying data sources. And, in meeting its aim of being a multi-data-source tool, Power BI *only* uses PQFLang for accessing data sources.

##### Database Compatability:
{: .fs-4 style="padding-left:2.4em;" .lh-default }

Relational databases are one of the most popular ways to store what I'll call 'proper data.'[^data] And PQFLang connects to the wide variety of database systems out there. 

[^data]: I.e. A large amount of data, and recording the types of events that organisations more-typically maintain records of (e.g. sales, inventory levels, etc.) in contrast to e.g. storing image files.

Relational databases also traditionally use row-based tables, and thus construct any requested output row-by-row. PQFLang is clearly complementary to such data sources, as most of its in-built functions are clearly designed to perform row-based operations.

Further, one of PQFLang's tricks is automatically identifying when sections of its code can be translated into the native language of query's data source.[^folding] For example, if the source is a SQL-native database, then SQL code with identical effect to sections of the PQFLang code will be identified.

[^folding]: And of course, instead of Excel/Power BI executing the section of PQFLang code, it will make the data source execute the equivalent native-code.

When PQFLang gets data from a source, sending the data from the source (e.g. into RAM, until it's eventually transformed and written to disk) consumes resources. So one benefit of this trick is that it can reduce the data that needs to be sent. I.e. Instead of Excel/Power BI receiving a large dataset and then analysing which subset is relevant, the data source performs the analysis and then only sends the relevant subset.

Intuitively, data sources are designed in cognisance of their native language, and so the native language ends up being the most performant language for doing anything with the data source. Thus, any code/tasks that are outsourced to the data source, results in it being performed as efficiently and performantly as possible.

As above, PQFLang is convenient because via Power Query Connectors (/ a single call of their function), it connects to many different sources. (E.g. Oracle databases, MySQL, SQL Server, Google BigQuery, Hadoop HDFS, web-hosted API's, or files e.g. in .xml, .json, .pdf, Parquet, .csv, Excel workbook formats etc.)  
However, PQFLang's range of SQL databases (whose native dialect of SQL, PQFLang is able to translate itself into) is particularly convenient. For example, our data could migrate from a MySQL to an Oracle database, and our PQFLang code would only need to change the small part that specifies the database (/ its location etc.). Despite only requiring such a low-effort change, the PQFLang code would then automatically start using transalations of itself into Oracle's SQL dialect. Whereas migrating between different databases is often a fiddly task.

##### Excel Compatability:
{: .fs-4 style="padding-left:2.4em;" .lh-default }

Excel is ubiquitous, and even if they are misguided, many people love it if they're data can be provided as an Excel file. So, if trying to provide data from multiple sources to such users, PQFLang is a good candidate. As above, it easily gets data from a wide range of sources.[^wide] And, of course, Excel can use PQFLang to load data straight into an Excel file. 

[^wide]: Power BI (/ its wider range of Power Query Connectors / those connectors' PQFLang) is able to connect to a wider range of sources than Excel. However, even then, Power BI has specific functionality for exporting to Excel.

Excel's ubiquity can also be useful if (espec. due to time constraints) it's unfeasible to provide access-permissions to the desired audience, or have the audience install specific apps in order to access data. For example, even in such difficult circumstances, it often isn't too difficult to get the relevant underlying data into e.g. a .csv file. And then one could share the .csv file and an accompanying .xlsx file that uses PQFLang to process that .csv file.  
Such a solution is likely undesirable, especially in the long-term. However, can be a handy short-term expedient.

##### Performance:
{: .fs-4 style="padding-left:2.4em;" .lh-default }

Performance is a significant factor in selecting a language. Since a program's tasks can vary so much, it's not possible to simply assert that e.g. language X performs 37% better than language Y.[^perf]  
However, for all we know, there are cases where PQFLang's performance justifies enduring the inconveniences described above.

[^perf]: Further, languages and their implementations are constantly updating. So, even if such blanket statements could be made, they would quickly become out-of-date.

It may be possible to discern which languages are, on average, the likely substitutes for PQFLang. And to discern how those languages perform on average.  
However, I haven't so-discerned. Instead, the below are some highly speculative reasons why PQFLang might at least not be a terrible language:
* Microsoft is a large tech company, with plenty of wealth and know-how. PQFLang is used to add value to apps such as Power BI and Excel, from which Microsoft presumably makes substantial revenue. So presumably, adequate resources are devoted to the development of PQFLang as a performant language.
* Relative to other programming languages, PQFLang is only capable of a narrow range of tasks.
  * For example, if one attempts to design, e.g. a function, that performs a variety of tasks or purposes (e.g. task A and task B) such multi-tasking ofen inevitably entails a trade-off between using a design that performs task A better, or task B better.
  * Presumably, PQFLang faces less such tade-offs than other languages do, and this assists its performance.






