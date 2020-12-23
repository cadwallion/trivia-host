import { useEffect, useState } from "react";
import {
  BrowserRouter as Router,
  Route,
  Link,
  useParams,
} from "react-router-dom";
import { Card, Col, Container, ListGroup, Nav, Row } from "react-bootstrap";
import { LinkContainer } from "react-router-bootstrap";
import "./App.css";

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
  const [questions, setQuestions] = useState([]);
  const [round, setRound] = useState(params.round);

  useEffect(() => {
    if (questions.length > 0) return;
    fetch("/round" + round)
      .then((res) => res.json())
      .then((res) => setQuestions(res.questions));
  });

  if (params.round !== round) {
    setQuestions([]);
    setRound(params.round);
  }

  if (!questions) return <div className="loading">Loading...</div>;

  return (
    <Card bg="light">
      <Card.Header as="h5">Round {round}</Card.Header>
      <ListGroup variant="flush">
        {questions.map((question) => (
          <Question
            key={questions.indexOf(question)}
            number={questions.indexOf(question) + 1}
            question={question}
          />
        ))}
      </ListGroup>
    </Card>
  );
};

const HomeInfo = (props) => {
  return (
    <Card style={{ width: "19rem" }}>
      <Card.Body>
        <Card.Title>There is no place like HOME</Card.Title>
        <Card.Text>Put HOME info stuff here yo!</Card.Text>
      </Card.Body>
    </Card>
  );
};

const RoundLink = (props) => {
  const { round } = props;
  return (
    <ListGroup.Item variant="info" as="li" action>
      <LinkContainer to={"/round/" + round}>
        <Nav.Link as={Link}>Round {round}</Nav.Link>
      </LinkContainer>
    </ListGroup.Item>
  );
};

function App() {
  const rounds = Array.from({ length: 9 }, (_, i) => i + 1);
  return (
    <Router>
      <Container>
        <Row>
          <Col xs={2}>
            <Nav aria-label="Main">
              <ListGroup>
                <ListGroup.Item variant="primary" as="li" action>
                  <LinkContainer to="/">
                    <Nav.Link as={Link}>Home</Nav.Link>
                  </LinkContainer>
                </ListGroup.Item>
                {rounds.map((round) => (
                  <RoundLink round={round} />
                ))}
              </ListGroup>
            </Nav>
          </Col>
          <Col xs={10}>
            <Route exact path="/">
              <HomeInfo />
            </Route>
            <Route path="/round/:round" component={QuestionList} />
          </Col>
        </Row>
      </Container>
    </Router>
  );
}

export default App;
