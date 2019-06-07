import React from 'react';
import PropTypes from 'prop-types';
import { createMuiTheme, withStyles } from '@material-ui/core/styles';
import ThemePallete from 'app-api/palette/themePalette';
import blue from '@material-ui/core/colors/blue';
import { Loading } from 'app-components';
import {
  ComposedChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  CartesianAxis,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts';
import data1 from './sampleData';

const styles = {
  chartFluid: {
    width: '100%',
    minWidth: 500,
    height: 450,
    overflowX: 'scroll'
  }
};

const theme = createMuiTheme(ThemePallete.yellowCyanTheme);
const color = ({
  main: theme.palette.primary.main,
  maindark: theme.palette.primary.dark,
  secondary: theme.palette.secondary.main,
  third: blue[500],
});

function CompossedLineBarArea(props) {
  const { classes, addresses: { data, error, loading } } = props;

  if (loading) {
    return <Loading />
  }

  if (error) {
    return <h1>error</h1>
  }
  const parseDataGraph = (parsingData) => parsingData.map(data => ({
    name: data.attributes.name,
    avgScore: data.attributes.avg_square_meter_price
  }))
  return (
    <div className={classes.chartFluid}>
      <ResponsiveContainer>
        <ComposedChart
          width={800}
          height={450}
          data={parseDataGraph(data)}
          margin={{
            top: 5,
            right: 30,
            left: 20,
            bottom: 5
          }}
          style={{ padding: '10' }}
        >
          {/* <XAxis axisLine={false} tickSize={3} tickLine={false} tick={{ stroke: 'none' }} />
          <YAxis dataKey="name" type="category" /> */}
          <XAxis dataKey="name" tickLine={5} />
          <YAxis axisLine={false} tickSize={3} tickLine={false} tick={{ stroke: 'none' }} />
          <CartesianGrid vertical={false} strokeDasharray="3 3" />
          <CartesianAxis vertical={false} />
          <Tooltip />
          <Legend />
          <Line type="monotone" dataKey="avgScore" strokeWidth={4} stroke={color.third} />
        </ComposedChart>
      </ResponsiveContainer>
    </div>
  );
}

CompossedLineBarArea.propTypes = {
  classes: PropTypes.object.isRequired,
  addresses: PropTypes.object.isRequired
};

export default withStyles(styles)(CompossedLineBarArea);
