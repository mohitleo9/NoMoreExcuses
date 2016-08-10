React = require('react');
ReactDOM = require('react-dom');

var Button = React.createClass({
  render: function() {
    return (
      <button type="button" className="btn btn-primary" onClick={this.props.clickHandler}>{this.props.text}</button>
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

var DataTable = React.createClass({
  getInitialState: function() {
    return {data: chrome.extension.getBackgroundPage().getRecordingData()};
  },
  componentDidMount: function(){
    chrome.extension.onMessage.addListener((request, sender, sendResponse) =>{
      if (request.message && request.message == 'popupData'){
        this.setState({data: request.data});
      }
    });
  },
  render: function(){
    return (
        <table className="table table-striped table-hover">
          <thead>
            <tr>
              <th> Action </th>
              <th> path </th>
            </tr>
          </thead>
          <tbody>
            {this.state.data.map( (row, index) =>{
                return (
                    <tr>
                      <td>{row.data.path}</td>
                      <td>{row.name}</td>
                    </tr>
                );
            })}
          </tbody>
        </table>
    );
  }
});

var PlayButton = React.createClass({
  play: function(){
    chrome.extension.getBackgroundPage().play();
    window.close();
  },
  render: function(){
    return (
    <Button clickHandler={this.play} text='play' />
    );
  }
});

var ClearButton = React.createClass({
  clear: function(){
    chrome.extension.getBackgroundPage().clearData();
  },
  render: function(){
    return (
    <Button clickHandler={this.clear} text='clear' />
    );
  }
});

var App = React.createClass({
  render: function(){
    return (
    <div className="container-fluid">
      <div className="btn-group">
        <RecordButton />
        <PlayButton />
        <ClearButton />
      </div>
      <br />
      <DataTable />
    </div>
    );
  }
});

ReactDOM.render(
  <App />,
  document.getElementById('react-content')
);
