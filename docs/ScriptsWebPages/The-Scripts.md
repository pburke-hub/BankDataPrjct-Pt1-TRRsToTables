---
layout: default
title: The Scripts
has_children: true
nav_order: 300
---

<!-- For now, let's have this as a parent page. However, ultimately, let's have it as something which has the ToC and highlights the order of and relations of the scripts (E.g. how `Tbl_AddLstCol` is a genuine helper-func.) -->

# The Scripts
{: .fs-6 .text-center .fw-700 .lh-default }

---

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

Clearly the `Result`-line is unnecessary. However, as it turns out, if we wish to cut and paste various parts of scripts into a Frankenstein script, (e.g. for debugging) then this form makes it easy to do so, while still being in a form for which Excel/Power BI will preview each step of the script.[^previews]

[^previews]: The 'Power Query Editor,' as accesed via Excel/Power BI, will preview the values of each step/variable of a script, only if the script's final line is also the output of the script.
  Testing whether x2 spaces will provide a multi-line footnote.

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

### What We Can't Use The Scripts To Do:
{: .fs-4 style="padding-left:1.2em;" .lh-default }

For many languages, the instructions for executing a script can be as simple as:{: .lh-tight }
* Save the script to "C\"; 
* Open a command line interface (in Windows, e.g. 'Command Prompt' or 'Powershell'); 
* Type "python C:\my_script.py" and then Enter.
{: .lh-tight }

Specifically, the language (e.g. Python above) has an interpreter which is able to execute script files.

PQFLang isn't offered as a language that comes with an interpreter. So, in the absence of an interpreter, we need something else to execute our code.  
As mentioned, Excel and Power BI can be used to execute PQFLang. (In addition, apps such as Visual Studio, and SQL Server Management Studio, can also use PQFLang.^[smss]\)

[^smss]: Although, an instance of SQL Server Analysis Services needs to be available, in addition to having the VS/SMSS app installed. And even then, to view or archive the output, another app like Excel or Power BI would still be needed.

The upshot is: Unfortunately, there isn't a convenient way to execute PQFLang scripts.

Some conveniences of scripts are:
* any text editor can author them 
  * (e.g. nice lightweight apps);
* multiple solutions that perform an identical task, can refer to the one script file for that task
  * As such, if that task's code needs to be updated, only one update is required. In constrast to altering a different file for each solution; and 
* When it's easy to execute a language's scripts via an Operating-System-interfacing CLI, then often it's easy to schedule such script to run periodically.

Microsoft's VS Code is a convenient text editor for authoring PQFLang code. However, the scripts we author can't be called/referred-to by Excel/Power BI.  
Instead, we need to copy and paste our script's content into Excel/Power BI.[^scripts-defn]

[^scripts-defn]: (In fact, although the PQFLang text files are referred to as scripts. They don't offer the same conveniences described above, so arguably they're not scripts.)

A final, conspicuous deficit of PQFLang is its inability to serialise. Most languages have an ability to create and write data to files. In PQFLang, such a feature *could* be available through a function like `Text.Write("This is line 1.", "C:\file.txt")`. However, such a function doesn't exist. 

Instead, we are forced to use 'load' the results of a PQFLang script in Excel/Power BI (which will result in the data being written somewhere in the .xlsx/.pbix file). And from there, we can copy the data into our desired file format.[^file-frmt]
[^file-frmt]: Although, quite likely requiring some minor transformations to the pasted-out Excel/Power BI data, before it's in the form that we desire for writing to the different type of file.

### Entering The Scripts Into The Power Query Editor:
{: .fs-3 style="padding-left:1.2em;" }

Both of Excel and Power BI accept PQFLang code through a GUI called the Power Query Editor. Within that GUI, we create 'Queries', and we can view and edit a Query's PQFLang code using the GUI's Advanced Editor.

Some unusual aspects of PQFLang and the Power Query Editor are:
* PQFLang variables are immutable. 
  * I.e. Once a value is assigned to a variable, we can't subsequently assign a different value to it.
* 'Queries'/scripts entered into Excel/Power BI must produce / correspond-to a single value.
* A 'query'/script may depend on other queries, because the other queries' names are available as if they are variables (and obviously refer to that query's output-value).

As mentioned above, your computer and your patience will thank you if none* of your queries are use the default properties/configuration of loading to the spreadsheet/data model. *Instead, only have a query configured to load, if its output is the data that you wish to serialise.


### Giving PQFLang A Fair Hearing:
{: .fs-3 style="padding-left:1.2em;" }

It's worth noting the downsides of using PQFLang. However, the following provides a more balanced impression. For example, based solely on the above, it's fair to conclude that PQFLang is best avoided, and shouldn't exist in the first place.

<!-- V = seems long. And def's a candidate for collapsible section! -->
#### Performance & Suitability For Relational Databases:
{: .fs-2 style="padding-left:1.2em;" }

Performance is a significant factor in selecting a language. Since potential program tasks/objectives can vary so much, it's not possible to simply say, e.g. that language X performs 37% better than language Y.[^perf]  
However, it's worth noting that, for all we know, there are cases where PQFLang's performance justifies enduring the inconveniences described above.
[^perf]: Further, languages and their implementations are constantly updating. So, even if such blanket statements could be made, they would quickly become out-of-date.

Relational databases are one of the most popular ways to store what I'll call 'proper data.'[^data]
[^data]: I.e. A large amount of data, and recording the types of events that organisations more-typically maintain records of (e.g. sales, inventory levels, etc.) in contrast to e.g. storing image files.

Anyway, PQFLang is designed to work with the wide variety of database systems out there. For example, one of Power BI's purposes is creating interactive, cloud-based dashboards that utilise a disparate range of underlying data sources. In other words, Power BI a reporting tool that extends, or adds value to, databases.  
And, with that purpose/objective, Power BI only uses PQFLang for accessing data sources. 

Further, one of PQFLang's tricks is automatically identifying when sections of its code can be translated into native language of the data source. (& Of course, haveing the data source use that equivalent native-code instead.)

For example, if the source is a SQL-native database, then Excel/Power BI will identify when there is SQL code with identical effect to a section of the PQFLang code.  
Usually, a data source is designed to work well with its native language. So using the native language offers the best performance. Further, doing some of the work at the data source, often creates a saving due to less data needing to transfer from the source to Excel/Power BI. 

So, on one level, PQFLang is a jack of all trades. Our data could be migrated from an Oracle database, to a MySQL database, and all we'd need to change in the PQFLang code is small part of the code that identifies the database / its location.

Similarly, relational databases traditionally work with tables by processing them row-by-row (a.k.a. store tables in a row-based fashion). The in-built functions that PQFLang provide are clrearly designed to perform row-based operations, and not so-much column-based operations.

(The above are relevant considerations when working with relational databases. However, of course, they do not apply to the provided hypothetical example which only uses csv files.)

#### Also:
{: .fs-2 style="padding-left:1.2em;" }

A rare characteristic of PQFLang is that all we need is Excel.[^all-we-need] So, although it's unlikely a sustainable solution, if time constraints etc. make it unfeasible to gain access-permissions and set up connections to relevant data, data can be put into files like .csv files, and accompanying .xlsx/.pbix files that process the data using PQFLang, can be shared.
[^all-we-need]: Or the ability to install the freely available Power BI Desktop.

Also, while our hypothetical example involves copying and pasting our code. It is possible to instead create a Power Query Connector. To do so, one authors several PQFLang scripts, which are then used to build a single .mez connector file. Then, by *reference*  to that file, Excel/Power BI is able to get the desired end-data, just like they're getting data from one of the other standard/available data sources (E.g. SQL Server, SAP HANA Database, Oracle Database, Google BigQuery, Parquet file, Hadoop HDF file, etc.).







