module PasswdGenXKCD
using Pkg.Artifacts
using BSON: @load

export generate

rootpath = artifact"wordlist"
list_path = joinpath(rootpath, "wordlist", "wordlist.bson")
@load list_path wordlist

function alphanumeric(count)
  String([Char(rand(0x30:0x40)) for i in 1:count])
end

function calc_break(word)
  br = round(Int,length(word)*rand())
  return (br < 2 || br > length(word)) ? calc_break(word) : br
end

function generate_word(w1, w2)
  div1 = calc_break(w1)
  div2 = calc_break(w2)
  w = w1[1:div1] * w2[div2:end]
  uppercasefirst(w)
end

function generate_password(count)
  passwd = ""
  for i in 1:count
    passwd *= generate_word(rand(wordlist), rand(wordlist))
    passwd *= alphanumeric(count == 1 ? count : count - 1)
  end
  passwd
end

function generate()
  w = generate_password(3)
  w = replace(w, r"’| |\n" => "")
  println("----------------------------------")
  println("PASSWORD: $w")
  println("----------------------------------")
end

end # module PasswdGenXKCD
