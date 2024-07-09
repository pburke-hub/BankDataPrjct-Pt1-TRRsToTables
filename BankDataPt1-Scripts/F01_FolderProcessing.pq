// F01_FolderProcessing

(dir as text) as table => let 

Result = let 

	FldrPath = Text.Trim(dir),

	FolderInfo = Folder.Contents(FldrPath),
		// NB: C/w `Folder.Files`, `Folder.Contents` ignores sub-directories' contents.
	// NB: The columns of `Folder.Contents`'s output include: "Content", "Name", "Folder Path", "Date accessed", "Date modified", "Date created", & "Extension". And of course, "Extension" & "Name" will contain `type text` values.

	OnlyCsvFiles = Table.SelectRows(
		FolderInfo,
		each ([Extension] = ".csv")
		),

	// Also NB: `Folder.Contents`'s output includes an "Attributes" column, it contains values that are `records` full of info about the row's file.
	RemoveHiddenFileRows = let 

		GetHiddenAttrib = Table.TransformColumns(
			OnlyCsvFiles,
			{"Attributes", 
				(rcrd) as logical => rcrd[Hidden], 
				type logical 
				} // Strangely, `Table.ExpandRecordColumn` expands [Hidden] as `type any`. Thus, we're using `Table.TransformColumns`. 
			), 
		ReNme = Table.RenameColumns(
			GetHiddenAttrib, {"Attributes", "Hidden"}
			), 
		Only_NonHidden_s = Table.RemoveMatchingRows(
			ReNme, 
			{[Hidden = true]}, 
			"Hidden"
			)
	in 
		Only_NonHidden_s,

	// Getting [HasX29Cols] Column Part 1: Getting the last 4 characters of the 28th column's header:
	AddPrep4Future_HasX29Cols_Col = let 
	
		Add_Duplic = Table.DuplicateColumn(
				RemoveHiddenFileRows, 
				"Content", "HasX29Cols", 
				type binary
				), 

		Csv_Args = [Columns = 29, Encoding = TextEncoding.Utf8
			], 
		ReadCSV = (csv_file) => Csv.Document(csv_file, Csv_Args 
			), // Recall: `Csv.Document` returns a table.

		HasX29Cols_InfoGetter = (csv_file as binary) as text => let 
				Header28th = ReadCSV(csv_file){5}[Column28],
					// Re `{5}`: Recall: Headers are in the csv-files' 6th row.
				Last4Chars = Text.End(
					Header28th, 4) // See `ErrMsg` below if unsure why we're doing this.
			in 
				Last4Chars,

		GetHdr28th_4Chrs = Table.TransformColumns(
			Add_Duplic, 
			{"HasX29Cols", 
				HasX29Cols_InfoGetter,
				type text
				}
			) 
		
	in 
		GetHdr28th_4Chrs, 
		// End of `AddPrep4Future_HasX29Cols_Col` expression / let-statement.

	// Getting [HasX29Cols] Column Part 2: Getting T/F based on whether we have "Bank" or "Name".
	Add_Hasx29Cols = Table.TransformColumns(
		AddPrep4Future_HasX29Cols_Col, 
		{"HasX29Cols", 
			each if (_ = "Bank") then true 
				else if (_ = "Name") then false 
				else error (ErrMsg & _),
			type logical
			}
		), 
		// Could have easily made a user-defined-func so that `GetHdr28th_4Chrs` & `Add_Hasx29Cols` are combined / performed by x1 `Table.TransformColumns` statement. However, `GetHdr28th_4Chrs` is useful for debugging.

	ErrMsg = "Header of 28th column is inconsistent with both of [Remitter Name] & [Remitting Bank]. Ergo, unsure if this is a 28/29-column version of the TRR format. The header value was: ", 

	RemoveIrrelevs = Table.SelectColumns(
		Add_Hasx29Cols, 
		{"Content", "Name", "HasX29Cols"}
		), 

	// If there's any .csv-file whose [HasX29Cols] error'ed, then unless we scan through the column now, lazy PQFLang won't raise the error. 
		// It's better to be alerted to errors when they happen (c/w e.g. in several scripts' time). So, let's force any errors to be raised now.
	HasX29_ErrorCheck = let 
		ErrorRows = Table.SelectRowsWithErrors(
			RemoveIrrelevs, {"HasX29Cols"}
			), 

		Error1st = try Table.FirstValue( // NB: break condition :)
			ErrorRows, 
			true // This `true` is an arbitrary default-value (see below - i.e. absence of `HasX29_ErrorCheck[Value]`).
			)
	in 
		Error1st,

	Output_Tbl = if HasX29_ErrorCheck[HasError] 
		then 
			HasX29_ErrorCheck[Error] 
		else 
			RemoveIrrelevs

in 
	Output_Tbl 
	// ^ End of `Result` definition.

in 
Result
// ^ End of script / unassigned func's definition.
