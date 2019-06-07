/* eslint-disable quotes */
/* eslint-disable react/destructuring-assignment */
import React, { Component } from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import injectReducer from "utils/injectReducer";
import injectSaga from "utils/injectSaga";
import brand from "app-api/dummy/brand";
import { PapperBlock, HelmetHeader } from "app-components";
import CompossedLineBarArea from "./CompossedLineBarArea";
import reducer, { addressesSelector, saga, index } from "./duck";

class BasicTable extends Component {
  constructor(props) {
    super(props);

    this.state = {
      addresses: null
    };
  }

  componentDidMount() {
    this.props.getAddresses();
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    const { addresses } = nextProps;
    let updatingState = {};
    if (addresses) {
      updatingState = {
        ...updatingState,
        addresses
      };
    }

    return {
      ...prevState,
      ...updatingState
    };
  }

  render() {
    const title = brand.name + " - Dashboard";
    const description = brand.desc;
    const { addresses } = this.state;

    return (
      <div>
        <HelmetHeader title={title} description={description} />
        <PapperBlock
          title="Statistic Chart"
          icon="ios-stats-outline"
          desc=""
          overflowX
        >
          <div>
            <CompossedLineBarArea addresses={addresses} />
          </div>
        </PapperBlock>
        <PapperBlock
          title="Table"
          whiteBg
          icon="ios-menu-outline"
          desc="UI Table when no data to be shown"
        >
          Table will come here
        </PapperBlock>
      </div>
    );
  }
}

const mapDispatchToProps = dispatch => ({
  getAddresses: (params = {}) => dispatch(index(params))
});

const mapStateToProps = createStructuredSelector({
  addresses: addressesSelector()
});

const key = "dashboard";
const withSaga = injectSaga({ key, saga });
const withReducer = injectReducer({ key, reducer });
const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withSaga,
  withReducer,
  withConnect
)(BasicTable);
