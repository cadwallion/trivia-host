import { useEffect, useState } from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useParams,
} from "react-router-dom";
import {
  Box,
  Flex,
  Heading,
  Timeline,
  SideNav,
  Text,
} from "@primer/components";
import "./App.css";

// The Question contains how to display a single question from a QuestionList.
// While not strictly necessary that this be split out, I find this cleans up
// the collection Component nicely. YMMV.
const Question = (props) => {
  const { number, question } = props;

  return (
    <Timeline.Item key={number}>
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
  let params = useParams();
  const [listState, setListState] = useState({
    round: params.round,
    questions: null,
  });

  useEffect(() => {
    if (listState.questions) return;
    fetch("/round" + listState.round)
      .then((res) => res.json())
      .then((res) =>
        setListState({ round: listState.round, questions: res.questions })
      );
  }, [listState, setListState]);

  const { questions, round } = listState;
  if (!questions) return <div class="loading">Loading...</div>;

  return (
    <Box>
      <Heading>Round {round}</Heading>
      <Timeline>
        {questions.map((question) => (
          <Question
            number={questions.indexOf(question) + 1}
            question={question}
          />
        ))}
      </Timeline>
    </Box>
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
      <Text>Round {round}</Text>
    </SideNav.Link>
  );
};

function App() {
  fetch("/ping")
    .then((res) => res.text())
    .then((res) => console.log(res));
  const rounds = Array.from({ length: 9 }, (_, i) => i + 1);
  return (
    <Box as={Flex} mr={15}>
      <SideNav bordered maxWidth={360} aria-label="Main" mr={30}>
        <SideNav.Link href={"/"}>
          <Text>Home</Text>
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
