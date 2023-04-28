module PasswdGenXKCD
using BSON: @load

export generate

function alphanumeric(count)
  String([Char(rand(0x30:0x40)) for i in 1:count])
end

function get_word(;loc="db")
  list_path = joinpath(loc,rand(readdir(loc)))
  @load list_path word_list
  return split(rand(word_list))[1]
end

function generate_word(w1, w2)
  div1 = round(Int,length(w1)*rand())
  div2 = round(Int,length(w2)*rand())
  w = w1[1:div1] * w2[div2:end]
  uppercasefirst(w)
end

function generate_password(count)
  passwd = ""
  for i in 1:count
    passwd *= generate_word(get_word(), get_word())
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
