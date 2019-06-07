import React from 'react';
import { Helmet } from 'react-helmet';
import brand from 'app-api/dummy/brand';
import { PapperBlock } from 'app-components';

class BlankPage extends React.Component {
  render() {
    const title = brand.name + ' - Blank Page';
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
        <PapperBlock title="Blank Page" desc="Some text description">
          Anthony super page will come here
        </PapperBlock>
      </div>
    );
  }
}

export default BlankPage;
