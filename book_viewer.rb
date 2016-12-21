require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

def each_chapter(&block)
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    # need to add another key/value that hold specifc paragraph
    # need to find the paragraph that contains query
    results << {number: number, name: name} if contents.include?(query)
  end

  results
end

def fetch_paragraphs(content, query)
  # need to split content into paragraphs and look
  # if each paragraph contains the query
  # use part of the in_paragraphs to help
  # how will we store the paragraphs, as we also
  # need to keep track of the ids?  
end

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

not_found do
  redirect "/"
end

get "/" do
  @title = "The adventure of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @chapter_number = params[:number].to_i
  chapter_name = @contents[@chapter_number - 1]
  @title = "Chapter #{@chapter_number}: #{chapter_name}"
  @chapter = File.read("data/chp#{@chapter_number}.txt")
 
  erb :chapter
end

get "/search" do
  @search_results = chapters_matching(params[:query])
  erb :search
end
  