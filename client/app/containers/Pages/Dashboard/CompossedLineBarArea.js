import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { createMuiTheme, withStyles } from '@material-ui/core/styles';
import ThemePallete from 'app-api/palette/themePalette';
import blue from '@material-ui/core/colors/blue';
import { Loading } from 'app-components';
import {
  Line,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  CartesianAxis,
  Tooltip,
  ResponsiveContainer,
  LineChart,
  ComposedChart
} from 'recharts';
import numeral from 'numeral';
import { Typography } from '@material-ui/core';

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

const CustomTooltip = ({ active, payload, label }) => {
  if (active) {
    return (
      <div style={{backgroundColor: 'white', padding: 10, border: '1px solid gray'}}>
        <p style={{textTransform: 'capitalize'}}>
          { label }
        </p>
        <p className="label">
          { numeral(payload[0].value).format('0,0') } / m²
        </p>
      </div>
    );
  }

  return null;
};

const CustomizedXAxisTick = ({ x, y, stroke, payload }) => {
  return(
    <g
      transform={`translate(${x},${y})`}
      style={{ textAlign: "center" }}>
      <text
        x={0}
        y={0}
        dy={16}
        textAnchor="end"
        fill="#666"
        style={{ textTransform: 'capitalize', fontSize: 13}}
        transform="rotate(-25)"
        >{payload.value}</text>
    </g>
  )
};

const CustomizedYAxisTick = ({ x, y, stroke, payload }) => {
  return(
    <g transform={`translate(${x},${y})`}>
      <text
        x={0}
        y={0}
        dy={16}
        textAnchor="end"
        fill="#666"
        style={{textTransform: 'capitalize'}}
        >{numeral(payload.value).format('0a')}</text>
    </g>
  )
};

function CompossedLineBarArea(props) {
  const { classes, addresses: { data, error, loading } } = props;

  if (loading) {
    return <Loading />
  }

  if (error) {
    return <Typography variant='subtitle1'>Server error!</Typography>
  }
  if (data) {
    const dataGraph = data.map(value => ({
      name: value.attributes.name,
      avgPrice: value.attributes.average_price
    }));

    return (
      <div className={classes.chartFluid}>
        <ResponsiveContainer>
          <ComposedChart
            width={800}
            height={450}
            data={dataGraph}
            style={{ padding: 10 }}
          >
            <XAxis
              dataKey="name"
              padding={{ right: 100, left: 20 }}
              interval={0}
              tick={<CustomizedXAxisTick />}
              tickMargin={20}
              orientation='top'
              axisLine={false}
            />
            <YAxis
              axisLine={true}
              tickSize={3}
              tickLine={true}
              padding={{ top: 100 }}
              tick={<CustomizedYAxisTick />} />
            <CartesianGrid vertical={false} strokeDasharray="3 3" />
            <CartesianAxis vertical={false} />
            <Tooltip content={<CustomTooltip />} />
            <Bar
              type="monotone"
              dataKey="avgPrice"
              strokeWidth={4}
              fill={color.third}
              barSize={35}/>
            <Line
              type="monotone"
              dataKey="avgPrice"
              strokeWidth={4}
              fill={color.secondary}
              stroke={color.main} />
          </ComposedChart>
        </ResponsiveContainer>
      </div>
    );
  }
  return <Loading />
}

CompossedLineBarArea.propTypes = {
  classes: PropTypes.object.isRequired,
  addresses: PropTypes.object.isRequired
};

export default withStyles(styles)(CompossedLineBarArea);
