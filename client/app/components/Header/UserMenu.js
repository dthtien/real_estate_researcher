import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import classNames from 'classnames';
import { Link } from 'react-router-dom';
import Avatar from '@material-ui/core/Avatar';
import IconButton from '@material-ui/core/IconButton';
import Button from '@material-ui/core/Button';
import Info from '@material-ui/icons/Info';
import Warning from '@material-ui/icons/Warning';
import Check from '@material-ui/icons/CheckCircle';
import Error from '@material-ui/icons/RemoveCircle';
import ExitToApp from '@material-ui/icons/ExitToApp';
import Badge from '@material-ui/core/Badge';
import Divider from '@material-ui/core/Divider';
import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Ionicon from 'react-ionicons';
import dummy from 'app-api/dummy/dummyContents';
import messageStyles from 'app-styles/Messages.scss';
import avatarApi from 'app-api/images/avatars';
import link from 'app-api/ui/link';
import styles from './header-jss';

class UserMenu extends React.Component {
  state = {
    anchorEl: null,
    openMenu: null
  };

  handleMenu = menu => (event) => {
    const { openMenu } = this.state;
    this.setState({
      openMenu: openMenu === menu ? null : menu,
      anchorEl: event.currentTarget
    });
  };

  handleClose = () => {
    this.setState({ anchorEl: null, openMenu: null });
  };

  render() {
    const { classes, dark } = this.props;
    const { anchorEl, openMenu } = this.state;
    return (
      <div>
        <IconButton
          aria-haspopup="true"
          onClick={this.handleMenu('notification')}
          color="inherit"
          className={classNames(classes.notifIcon, dark ? classes.dark : classes.light)}
        >
          <Badge className={classes.badge} badgeContent={4} color="secondary">
            <Ionicon icon="ios-notifications-outline" />
          </Badge>
        </IconButton>
        <Menu
          id="menu-notification"
          anchorEl={anchorEl}
          anchorOrigin={{
            vertical: 'top',
            horizontal: 'right',
          }}
          transformOrigin={{
            vertical: 'top',
            horizontal: 'right',
          }}
          className={classes.notifMenu}
          PaperProps={{
            style: {
              width: 350,
            },
          }}
          open={openMenu === 'notification'}
          onClose={this.handleClose}
        >
          <MenuItem onClick={this.handleClose}>
            <div className={messageStyles.messageInfo}>
              <Avatar alt="User Name" src={avatarApi[0]} />
              <ListItemText primary={dummy.text.subtitle} secondary={dummy.text.date} />
            </div>
          </MenuItem>
          <Divider inset />
          <MenuItem onClick={this.handleClose}>
            <div className={messageStyles.messageInfo}>
              <Avatar className={messageStyles.icon}>
                <Info />
              </Avatar>
              <ListItemText primary={dummy.text.sentences} className={classes.textNotif} secondary={dummy.text.date} />
            </div>
          </MenuItem>
          <Divider inset />
          <MenuItem onClick={this.handleClose}>
            <div className={messageStyles.messageSuccess}>
              <Avatar className={messageStyles.icon}>
                <Check />
              </Avatar>
              <ListItemText primary={dummy.text.subtitle} className={classes.textNotif} secondary={dummy.text.date} />
            </div>
          </MenuItem>
          <Divider inset />
          <MenuItem onClick={this.handleClose}>
            <div className={messageStyles.messageWarning}>
              <Avatar className={messageStyles.icon}>
                <Warning />
              </Avatar>
              <ListItemText primary={dummy.text.subtitle} className={classes.textNotif} secondary={dummy.text.date} />
            </div>
          </MenuItem>
          <Divider inset />
          <MenuItem onClick={this.handleClose}>
            <div className={messageStyles.messageError}>
              <Avatar className={messageStyles.icon}>
                <Error />
              </Avatar>
              <ListItemText primary="Suspendisse pharetra pulvinar sollicitudin. Aenean ut orci eu odio cursus lobortis eget tempus velit. " className={classes.textNotif} secondary="Jan 9, 2016" />
            </div>
          </MenuItem>
        </Menu>
        <Button onClick={this.handleMenu('user-setting')}>
          <Avatar
            alt={dummy.user.name}
            src={dummy.user.avatar}
          />
        </Button>
        <Menu
          id="menu-appbar"
          anchorEl={anchorEl}
          anchorOrigin={{
            vertical: 'top',
            horizontal: 'right',
          }}
          transformOrigin={{
            vertical: 'top',
            horizontal: 'right',
          }}
          open={openMenu === 'user-setting'}
          onClose={this.handleClose}
        >
          <MenuItem onClick={this.handleClose} component={Link} to={link.profile}>My Profile</MenuItem>
          <MenuItem onClick={this.handleClose} component={Link} to={link.calendar}>My Calendar</MenuItem>
          <MenuItem onClick={this.handleClose} component={Link} to={link.email}>
            My Inbox
            <ListItemIcon>
              <Badge className={classNames(classes.badge, classes.badgeMenu)} badgeContent={2} color="secondary">&nbsp;</Badge>
            </ListItemIcon>
          </MenuItem>
          <Divider />
          <MenuItem onClick={this.handleClose} component={Link} to="/">
            <ListItemIcon>
              <ExitToApp />
            </ListItemIcon>
            Log Out
          </MenuItem>
        </Menu>
      </div>
    );
  }
}

UserMenu.propTypes = {
  classes: PropTypes.object.isRequired,
  dark: PropTypes.bool,
};

UserMenu.defaultProps = {
  dark: false
};

export default withStyles(styles)(UserMenu);
