# AsciiTrees.jl
# 20220123--20220124

module AsciiTrees

export AsciiTree, read_tree, write_table, write_tables

function parse_tree(s::String)
	# deterministic finite automaton
	stack = Int[]
	parentheses = Tuple{Int, Int}[]
	otu_list = String[]
	n = 0
	state = 0 # 1: reading otu; 2: reading nonsense
	otu = ""
	for c = s
		if c in ['(', ')', ',', ';']
			if otu != ""
				push!(otu_list, otu)
				n += 1
				otu = ""
			end
			state = 0
			if c == '('
				push!(stack, n + 1)
			elseif c == ')'
				t = pop!(stack)
				push!(parentheses, (t, n))
				state = 2
			elseif c == ';'
				break
			end
		elseif c == ':'
			state = 2
		elseif state != 2
			state = 1
			otu *= c
		end
	end
	n, otu_list, parentheses
end

function elongate!(ascii_table, i, m, s, b) 
	l = length(ascii_table[i])
	ascii_table[i] = s * b^(m-l) * ascii_table[i]
end

function build_ascii_tree(parentheses, n)
	ascii_table = repeat(["─"], n)
	start = trues(n)
	for (s, t) = parentheses
		m = maximum(length.(ascii_table[s:t]))
		s1, b1, s0, b0 = '└', '─', '　', '　'
		for i = t:-1:s+1
			if start[i]
				elongate!(ascii_table, i, m, s1, b1)
				s1, s0 = '├', '│'
				start[i] = false
			else
				elongate!(ascii_table, i, m, s0, b0)
			end
		end
		elongate!(ascii_table, s, m, '┬', b1)
	end
	ascii_table
end

struct AsciiTree
	n
	otu_list
	parentheses
	ascii_table
	function AsciiTree(str::String)
		n, otu_list, parentheses = parse_tree(str)
		ascii_table = build_ascii_tree(parentheses, n)
		new(n, otu_list, parentheses, ascii_table)
	end
end

function read_tree(filename::String)
	tree = String(read(filename))
	AsciiTree(tree)
end

function Base.show(at::AsciiTree)
	repl_heads = [replace(h, '　' => ' ') for h = at.ascii_table]
	println('\n', join(repl_heads .* ' ' .* at.otu_list, '\n'), '\n')
end
Base.display(at::AsciiTree) = Base.show(at::AsciiTree)

function write_strings(filename::String, strings)
	open(filename, "w") do fout
		write(fout, join(strings, '\n'), '\n')
	end
	nothing
end

function write_table(filename::String, at::AsciiTree, sep=' ')
	write_strings(filename, at.ascii_table .* sep .* at.otu_list)
end

function write_tables(file_ascii::String, file_otu::String, at::AsciiTree)
	write_strings(file_ascii, at.ascii_table)
	write_strings(file_otu, at.otu_list)
end

end
