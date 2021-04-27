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

  def parse_page_old page
    match = page.text.match(/^\s+(?<round>.+)\n{2,}\s+(?<category>.+)\n{2,}(?<questions>.*)/m)
    category = match["category"].strip
    data = match["questions"].split(/\n{2,4}/)

    data.map do |item| 
      if match = item.strip.gsub("\n      ", " ").gsub("\n", "").match(QUESTION_PATTERN)
        { 
          category: category,
          question: match.named_captures["question"].strip + "?",
          answer: match.named_captures["answer"].strip,
        }
      else
        {
          category: category,
          data: data,
        } 
      end
    end
  end

  def parse_page page
    data = page.text.split(/\d+\./)
    category = data.shift
    case category
    when /Picture Round/
      { category: "Picture Round", questions: parse_picture_round(data, page.xobjects) }
    when /Audio Round/
      { category: "Audio Round", data: data }
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
end
