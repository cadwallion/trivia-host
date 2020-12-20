import { useEffect, useState } from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useParams,
} from "react-router-dom";
import {
  ButtonGroup,
  Button,
  Box,
  Flex,
  Heading,
  Timeline,
  SideNav,
} from "@primer/components";
import "./App.css";

// The Question contains how to display a single question from a QuestionList.
// While not strictly necessary that this be split out, I find this cleans up
// the collection Component nicely. YMMV.
const Question = (props) => {
  const { number, question } = props;

  return (
    <>
      <Timeline.Item key={number}>
        <Timeline.Badge>{number}</Timeline.Badge>
        <Timeline.Body>{question}</Timeline.Body>
      </Timeline.Item>
    </>
  );
};

// The QuestionList contains the representation of Questions for a given Round.
// We use the useEffect function hook to handle fetching the question data and
// updating the state of the Component.  We do it this way because state changes
// cause a re-render of the Component.  Once the fetch completes, we'll have data
// to display.
const QuestionList = (props) => {
  let params = useParams();
  const [listState, setListState] = useState({
    round: params.round,
    questions: null,
    currentQuestion: 1,
  });

  useEffect(() => {
    if (listState.questions) return;
    fetch("/round" + listState.round)
      .then((res) => res.json())
      .then((res) =>
        setListState({
          round: listState.round,
          questions: res.questions,
          currentQuestion: listState.currentQuestion,
        })
      );
  }, [listState, setListState]);

  // @TODO: Determine if this is a memoization issue or not.
  // this looks nicer but if it's a bug then it needs squashing
  const { round, questions, currentQuestion } = listState;
  if (!questions) return <div className="loading">Loading...</div>;

  const showCurrentQuestions = () => {
    let questionList = questions.slice(0, currentQuestion);
    return (
      <Timeline>
        {questionList.map((question) => (
          <Question
            number={questionList.indexOf(question) + 1}
            question={question}
          />
        ))}
      </Timeline>
    );
  };

  const changeQuestion = (direction) => {
    let questionNumber = currentQuestion;
    if (currentQuestion + direction < 1 || currentQuestion + direction > questions.length) return;
    questionNumber += direction;
    setListState({
      round: round,
      questions: questions,
      currentQuestion: questionNumber
    });
  }

  return (
    <>
      <Box>
        <Box ml={1} width={400}>
          <Heading>Round {round}</Heading>
          <Box as="span">
            <ButtonGroup display="block" my={2}>
              <QuestionButton type="Prev" onClick={changeQuestion.bind(this, -1)} />
              <QuestionButton type="Next" onClick={changeQuestion.bind(this, 1)} />
            </ButtonGroup>
          </Box>
        </Box>
        <Box>
          {showCurrentQuestions()}
        </Box>
      </Box>
    </>
  );
};

const RoundLink = (props) => {
  let { round } = props;

  return (
    <li key={round}>
      <Link to={"/round" + round}>Round {round}</Link>
    </li>
  );
};

const SideNavLink = (props) => {
  let { round } = props;

  return (
    <SideNav.Link href={"/round" + round}>
      <Heading as="h5" fontSize={1}>
        Round {round}
      </Heading>
    </SideNav.Link>
  );
};

const QuestionButton = (props) => {
  return (
    <Button
      type="button"
      onClick={props.onClick}
    >
      {props.type}
    </Button>
  );
};

function App() {
  fetch("/ping")
    .then((res) => res.text())
    .then((res) => console.log(res));
  const rounds = Array.from({ length: 9 }, (_, i) => i + 1);
  return (
    <Box as={Flex} mr={15} bg={"blue.1"}>
      <SideNav bg={"blue.3"} bordered maxWidth={360} aria-label="Main" mr={30}>
        <SideNav.Link href={"/"}>
          <Heading as="h5" fontSize={1}>
            Home
          </Heading>
        </SideNav.Link>
        {rounds.map((round) => (
          <SideNavLink round={round} />
        ))}
      </SideNav>
      <Router>
        <Switch>
          <Route path="/round:round">
            <QuestionList />
          </Route>
          <Route exact path="/">
            <nav>
              <ul>
                {rounds.map((round) => (
                  <RoundLink round={round} />
                ))}
              </ul>
            </nav>
          </Route>
        </Switch>
      </Router>
    </Box>
  );
}

export default App;
