React = require('react');
ReactDOM = require('react-dom');

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
        recording: chrome.extension.getBackgroundPage().recording()
        };
  },
  toggleRecording: function(){
    var recording = !this.state.recording;
    this.setState({recording: recording});
    chrome.browserAction.setIcon({"path": recording ? "/icons/recording.png" : "/icons/icon.png"});
    chrome.extension.getBackgroundPage().recording(recording);
    window.close();
  },
  render: function(){
    return (
    <Button clickHandler={this.toggleRecording} text={this.state.recording ? 'stop' : 'record'}/>
    );
  }
});

var PlayButton = React.createClass({
  play: function(){
    chrome.extension.getBackgroundPage().play();
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
