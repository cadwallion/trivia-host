require "stringio"

class TriviaImporter
  include ActiveModel::Model
  attr_reader :reader, :pages
  attr_accessor :game, :file

  QUESTION_PATTERN = /\d{1,}\.\s+(?<question>.+)\?(?<answer>.+)/

  def reader
    @reader ||= PDF::Reader.new(@file)
  end

  def import
    parse 
    add_rounds
  end

  def add_rounds
    pages.each do |page|
      round = game.new_round(category: page[:category], question_count: 0)

      case page[:category]
      when "Picture Round"
        round.round_type = "image"
      when "Audio Round"
        round.round_type = "audio"
      end

      page[:questions].each_index do |index|
        raw_question = page[:questions][index]
        question = round.questions.build({
          position: index,
          answer: raw_question[:answer]
        })

        case page[:category]
        when "Picture Round"
          io = StringIO.new(raw_question[:question])
          question.picture.attach(io: io, filename: "#{index}.jpg")
          question.text = "Picture"
        when "Audio Round"
          question.url = raw_question[:question]
        else
          question.text = raw_question[:question]
        end
      end
    end
  end

  def parse
    @pages = reader.pages[1..-1].map do |page|
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
      { category: category.chomp.strip.split("\n").last.strip, questions: parse_question_round(data) }
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
      match = answer.match(/“(?<title>.*)” .{1} (?<artist>.+)/)
      if match
        formatted_answer = "\"#{match["title"]}\" - #{match["artist"]}"
      else
        formatted_answer = answer.split("\n").first
      end
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
    [{question: question, answer: "Unknown" }] + options
  end
end
