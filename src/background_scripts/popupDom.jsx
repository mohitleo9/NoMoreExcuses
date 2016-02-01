React = require('react');
ReactDOM = require('react-dom');
popupService = require('./popupService');

var sendMessage = popupService.sendMessage;

var Button = React.createClass({
  render: function() {
    return (
      <button onClick={this.props.clickHandler}>{this.props.text}</button>
    );
  }
});

var RecordButton = React.createClass({
  getInitialState: function() {
    return {
        recording: chrome.extension.getBackgroundPage().isRecording()
        };
  },
  toggleRecording: function(){
    this.setState({recording: !this.state.recording});
    chrome.extension.getBackgroundPage().toggleRecording();
    sendMessage({recording: this.state.recording});
  },
  render: function(){
    return (
    <Button clickHandler={this.toggleRecording} text={this.state.recording ? 'stop' : 'start'}/>
    );
  }
});

var PlayButton = React.createClass({
  play: function(){
    sendMessage({playBack: true});
  },
  render: function(){
    return (
    <Button clickHandler={this.play} text='play' />
    );
  }
});

var App = React.createClass({
  render: function(){
    return (
    <div>
      <RecordButton />
      <PlayButton />
    </div>
    );
  }
});

ReactDOM.render(
  <App />,
  document.getElementById('react-content')
);
