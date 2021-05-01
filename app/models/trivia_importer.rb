class TriviaImporter
  attr_reader :reader, :pages

  QUESTION_PATTERN = /\d{1,}\.\s+(?<question>.+)\?(?<answer>.+)/


  def initialize file
    @file = file
    @reader = PDF::Reader.new(@file)
  end

  def import
    @pages = @reader.pages[1..-1].map do |page|
      parse_page(page)
    end
  end

  def parse_page page
    data = page.text.split(/\d+\./)
    category = data.shift
    case category
    when /Picture Round/
      { category: "Picture Round", questions: parse_picture_round(data, page.xobjects) }
    when /Audio Round/
      { category: "Audio Round", questions: parse_audio_round(data) }
    when /Final Trivia Question/
      match = category.match(/Category: (?<category>.+)\n+Question: (?<question>.+):/m)
      data.unshift(match["question"])
      { category: match["category"].chomp, questions: parse_final_round(data) }
    else
      { category: category, questions: parse_question_round(data) }
    end
  end
  
  def parse_question_round data
    data.map do |item|
      question, answer = item.strip.gsub("\n      ", " ").gsub("\n", "").split("?")
      {
        question: question&.strip,
        answer: answer&.strip,
      }
    end
  end

  def parse_picture_round data, xobjects
    answers = data.map do |answer|
      answer.gsub("\n", "").gsub(/\s+$/, "").strip
    end
    images = xobjects.map do |name, stream|
      stream.data 
    end

    answers.length.times.map do |index|
      { 
        question: images[index],
        answer: answers[index]
      } 
    end
  end

  def parse_audio_round data
    question_url_fragment = data.last.match(/https:\/\/quiznight.vids.io\/videos\/(.*)/)[1]
    question_url = "https://quiznight.vids.io/videos/#{question_url_fragment}"
    data.map do |answer|
      match = answer.match(/“(?<title>.*)” – (?<artist>.+)/)
      formatted_answer = "\"#{match["title"]}\" - #{match["artist"]}"
      {
        question: question_url,
        answer: formatted_answer
      }
    end
  end

  def parse_final_round data
    question = data.shift.gsub("\n", " ")
    question_count =  data.length / 2
    options = question_count.times.map do |index|
      {
        question: data[index].gsub("\n", "").gsub("Answer:", "").strip,
        answer:  data[index+question_count].gsub("\n", "").strip
      }
    end
    [{question: question, answer: "lolgetrekt" }] + options
  end
end