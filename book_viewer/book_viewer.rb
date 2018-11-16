require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


before do
  @contents = File.readlines ("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map!.with_index do |para, i|
      "<p id=para#{i + 1}>#{para}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))
  end
end

not_found do
  redirect '/'
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i
  redirect '/' unless (1..@contents.size).cover? @number
  @chapter = File.read ("data/chp#{@number}.txt")
  @names = @chapter_names = File.readlines ("data/toc.txt"), chomp: true
  @title = @names[@number.to_i - 1]
  erb :chapter
end

def each_chapter # breaks an entire chapter into components (number, title, text)
  @contents.each_with_index do |name, i|
    number = i + 1
    contents = File.read ("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapter_matching(query)
  results = {}
  return results unless query

  each_chapter do |number, name, contents|
    if contents.include? query
      results[name] = {number: number, paragraphs: {}}

      contents.split(/\n\n/).each_with_index do |text, i|
        results[name][:paragraphs][(i + 1)] = text if text.include? query
      end
    end
  end
  results
end

get "/search" do
  @results = chapter_matching(params[:query])

  erb :search
end
