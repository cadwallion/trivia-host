import { useEffect, useState } from 'react';
import { Box, Heading, Timeline } from '@primer/components';
import './App.css';

// The Question contains how to display a single question from a QuestionList.
// While not strictly necessary that this be split out, I find this cleans up
// the collection Component nicely. YMMV.
const Question = (props) => {
  const { number, question } = props;

  return (
    <Timeline.Item>
      <Timeline.Badge>{number}</Timeline.Badge>
      <Timeline.Body>{question}</Timeline.Body>
    </Timeline.Item>
  );
};

// The QuestionList contains the representation of Questions for a given Round.
// We use the useEffect function hook to handle fetching the question data and
// updating the state of the Component.  We do it this way because state changes
// cause a re-render of the Component.  Once the fetch completes, we'll have data
// to display.
const QuestionList = (props) => {
  const [listState, setListState] = useState({
    round: props.round,
    questions: null
  })

  useEffect(() => {
    if (listState.questions) return;
    fetch("/round" + listState.round)
      .then(res => res.json())
      .then(res => setListState({ round: listState.round, questions: res.questions }))
  }, [listState, setListState]);

  const { questions, round } = listState;
  if (!questions) return <div class="loading">Loading...</div>;

  return (
    <Box>
      <Heading>Round {round}</Heading>
      <Timeline>
        {
          questions.map((question) => <Question number={questions.indexOf(question) + 1} question={question} />)
        }
      </Timeline>
    </Box>
  )
};

function App() {
  fetch("/ping").then(res => res.text()).then(res => console.log(res));
  return (
    <Box>
      <QuestionList round={1} />
      <QuestionList round={2} />
      <QuestionList round={3} />
      <QuestionList round={4} />
      <QuestionList round={5} />
      <QuestionList round={6} />
      <QuestionList round={7} />
      <QuestionList round={8} />
      <QuestionList round={9} />
    </Box>
  );
}

export default App;
