import React, { Component } from 'react';
import { Helmet } from 'react-helmet';
import brand from 'app-api/dummy/brand';
import { PapperBlock } from 'app-components';
import CompossedLineBarArea from './CompossedLineBarArea';
import StrippedTable from '../Table/StrippedTable';
import { AddressesApi } from 'app-api/controllers';

class BasicTable extends Component {
  componentDidMount(){
    const addressesApi = new AddressesApi;
    addressesApi.index() 
  }
  render() {
    const title = brand.name + ' - Dashboard';
    const description = brand.desc;
    return (
      <div>
        <Helmet>
          <title>{title}</title>
          <meta name="description" content={description} />
          <meta property="og:title" content={title} />
          <meta property="og:description" content={description} />
          <meta property="twitter:title" content={title} />
          <meta property="twitter:description" content={description} />
        </Helmet>
        <PapperBlock title="Statistic Chart" icon="ios-stats-outline" desc="" overflowX>
          <div>
            <CompossedLineBarArea />
          </div>
        </PapperBlock>
        <PapperBlock title="Table" whiteBg icon="ios-menu-outline" desc="UI Table when no data to be shown">
          <div>
            <StrippedTable />
          </div>
        </PapperBlock>
      </div>
    );
  }
}

export default BasicTable;
