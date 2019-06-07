import React from 'react';
import { Helmet } from 'react-helmet';

const HelmetHeader = ({title, description}) =>(
  <Helmet>
    <title>{title}</title>
    <meta name="description" content={description} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="twitter:title" content={title} />
    <meta property="twitter:description" content={description} />
  </Helmet>
)

export default HelmetHeader;