<!--README.md-->
<!--20220128-->

# AsciiTrees.jl

`AsciiTrees.jl` is a Julia package that reads Newick phylotree files and expands them in plain text using box drawing characters and spaces, in a way similar to the `tree` command in Windows. Branch lengths and node markings (e.g. bootstrap values) are ignored.

## Usage

Say we have a Newick format string (adapted from Yusupov et al., 2021, 10.1016/j.pld.2020.07.008)
```julia
str = "((((Allium_cepa,Allium_galanthum),(Allium_fistulosum,Allium_altaicum)),((Allium_oschaninii,Allium_praemixtum),Allium_pskemense)),Allium_sativum);";
```
This can be the argument to instantiate an `AsciiTree` struct i.e. 
```julia
at = AsciiTrees.AsciiTree(str)
```
which displays its topology on the REPL
```julia
┬┬┬┬─ Allium_cepa
│││└─ Allium_galanthum
││└┬─ Allium_fistulosum
││ └─ Allium_altaicum
│└┬┬─ Allium_oschaninii
│ │└─ Allium_praemixtum
│ └── Allium_pskemense
└──── Allium_sativum
```
In case that the tree is stored in file, say `Allium_sect_Cepa.tre`, the instance can be built by reading the file by 
```julia
at = AsciiTrees.read_tree("Allium_sect_Cepa.tre")
```

The topology can be written, either altogether into one file literally containing the content displayed above by 
```julia
AsciiTrees.write_table("Table.txt", at)
```
or separately (branches structure and OTU names) into two files severally containing the branch structure and OTU names by 
```julia
AsciiTrees.write_tables("Table_Branch.txt", "Table_OTU.txt", at)
```
The latter output style is suitable for text editors capable of split-screen viewing and editing.

## Notes

The width (half or full) of box drawing characters is dependent on fonts, and thus it is not consistent whether to align the characters by full-width spaces or half-widths. Finer control in this package will be available in the future.

## Log

- 20220124: AsciiTrees.jl
- 20220128: README.md
