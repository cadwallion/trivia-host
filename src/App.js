import { useEffect, useState } from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useParams,
} from 'react-router-dom';
import {
  Card,
  Col,
  Container,
  ListGroup,
  Nav,
  Row
} from "react-bootstrap";
import './App.css';

// The Question contains how to display a single question from a QuestionList.
// While not strictly necessary that this be split out, I find this cleans up
// the collection Component nicely. YMMV.
const Question = (props) => {
  const { number, question } = props;

  return (
    <ListGroup.Item key={number}>
      {number}. {question}
    </ListGroup.Item>
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
    questions: null
  })

  useEffect(() => {
    if (listState.questions) return;
    fetch("/round" + listState.round)
      .then(res => res.json())
      .then(res => setListState({ round: listState.round, questions: res.questions }))
  }, [listState, setListState]);

  const { questions, round } = listState;
  if (!questions) return <div className="loading">Loading...</div>;

  return (
    <Card bg="light">
      <Card.Header as="h5">Round {round}</Card.Header>
      <ListGroup variant="flush">
        {
          questions.map((question) => <Question key={questions.indexOf(question)} number={questions.indexOf(question) + 1} question={question} />)
        }
      </ListGroup>
    </Card>
  )
};

const RoundLink = (props) => {
  let { round } = props;

  return (
    <li key={round}>
      <Link to={"/round/" + round}> Round {round}</Link>
    </li>
  );
}

function App() {
  fetch("/ping").then(res => res.text()).then(res => console.log(res));
  const rounds = Array.from({ length: 9 }, (_, i) => i + 1);
  return (
    <Router>
      <Container>
        <Row>
          <Col xs={2}>
            <Nav aria-label="Main">
              <Nav.Link href="/round/1">Round 1</Nav.Link>
              <Nav.Link href="/round/2">Round 2</Nav.Link>
              <Nav.Link href="/round/3">Round 3</Nav.Link>
              <Nav.Link href="/round/4">Round 4</Nav.Link>
              <Nav.Link href="/round/5">Round 5</Nav.Link>
              <Nav.Link href="/round/6">Round 6</Nav.Link>
              <Nav.Link href="/round/7">Round 7</Nav.Link>
              <Nav.Link href="/round/8">Round 8</Nav.Link>
              <Nav.Link href="/round/9">Round 9</Nav.Link>
            </Nav>
          </Col>
          <Col xs={10}>
            <Switch>
              <Route path="/round/:round">
                <QuestionList />
              </Route>
              <Route exact path="/">
                <nav>
                  <ul>
                    {rounds.map((round) => <RoundLink key={round} round={round} />)}
                  </ul>
                </nav>
              </Route>
            </Switch>
          </Col>
        </Row>
      </Container>
    </Router>
  );
}

export default App;
